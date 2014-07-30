class QuestionsController < ApplicationController

  def index
    @ratings = Movie.all.map{|m| m.rating}.uniq
    @genres = Genre.all
    @question = Question.new
  end

  def create
    @question = Question.new
    @question.selection = params[:user_genre]
    @question.user_weight = params[:user_weight]
    @question.question_type = params[:question_type]
    @question.add_to_user_responses
    @question.find_my_movies
    session[:score] = @question.movie_scores
    redirect_to '/'
  end

  def update
    # @question = Question.find_by
    # @question.selection = params[:question][:selection]
    # @question.user_weight = params[:user_weight]
    # @question.find_my_movies
  end


end
