class MoviesController < ApplicationController

  def index
    @score = session[:score] 
    @movies = Movie.all
  end
end
