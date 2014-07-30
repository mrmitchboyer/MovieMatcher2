require 'pry'
class Movie < ActiveRecord::Base

  has_many :movie_genres
  has_many :movie_actors
	has_many :genres, through: :movie_genres
	has_many :actors, through: :movie_actors

  attr_accessor :score

end
