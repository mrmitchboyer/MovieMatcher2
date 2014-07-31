class TopActor < ActiveRecord::Base

	def self.find_intersection
		random_actors = TopActor.all.map {|a| a.name}.shuffle
		i = 0
		actors_arr = []
		random_actors.each do |actor|
			if Actor.find_by(name: actor)
				i += 1
				actors_arr << Actor.find_by(name: actor) unless actors_arr.include?(Actor.find_by(name: actor))
			end
			break if i > 3
		end
		return actors_arr
	end
end
