class QuestionsController < ApplicationController

  def index
    @genres = Genre.all
    @ratings = Movie.all.map{ |m| m.rating }.uniq
    @runtimes = Question.runtimes
    @actors = TopActor.find_intersection
    @directors = TopDirector.find_intersection
  end

  def create
    @question = Question.new
    @question.seed = question_params 
    @question.find_my_movies
    session[:score] = @question.final_scores
    redirect_to movies_path
  end

  private
    def question_params
      params.require(:ans)
    end


end
