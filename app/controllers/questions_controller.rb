class QuestionsController < ApplicationController

  def index
    @genres = Genre.all
    @question = Question.new
  end

  def create
    @question = Question.new
    raise params.inspect 
  end
end
