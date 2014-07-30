class QuestionsController < ApplicationController

  def index
    @genres = Genre.all
    @question = Question.new
  end

  def create
    @question = Question.new
    @question.selection = params[:question][:selection]
    @question.user_weight = params[:user_weight]
    @question.find_my_movies
  end

  def update
    # @question = Question.find_by
    # @question.selection = params[:question][:selection]
    # @question.user_weight = params[:user_weight]
    # @question.find_my_movies
  end


end
