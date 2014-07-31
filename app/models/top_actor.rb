class TopActor < ActiveRecord::Base

  def self.find_intersection
    random_actors = TopActor.all.map {|a| a.name}.shuffle
    current_actors = TopActor.all
    i = 0
    actors_arr = []
    random_actors.each do |actor|
      if Actor.find_by(name: actor)
        i += 1
        actors_arr << Actor.find_by(name: actor) unless actors_arr.include?(Actor.find_by(name: actor))
      end
      break if i > 3
    end

    while actors_arr.uniq.count < 4
      actors_arr << current_actors.shuffle.first
    end

    return actors_arr.uniq
  end
end
