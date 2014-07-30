require 'pry'
class Movie < ActiveRecord::Base

  has_many :movie_genres
  has_many :movie_actors
	has_many :genres, through: :movie_genres
	has_many :actors, through: :movie_actors

  attr_accessor :score

  def find_movie_score(movie_scores)
  	movie_scores.each do |title|
  		binding.pry
  		return title[1] if Movie.find_by(:title => title[0]).title == title[0]
  	end
  end
end
