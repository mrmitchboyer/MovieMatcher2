class TopDirector < ActiveRecord::Base

    def self.find_intersection
    random_directors = TopDirector.all.map {|a| a.name}.shuffle
    current_movie_directors = Movie.all.pluck(:director)
    i = 0
    directors_arr = []
    random_directors.each do |director|
      if current_movie_directors.include?(director)
        i += 1
        directors_arr << director
      end
      break if i > 3
    end

    while directors_arr.uniq.count < 4
      directors_arr << current_movie_directors.shuffle.first
    end

    return directors_arr.uniq
  end

end
