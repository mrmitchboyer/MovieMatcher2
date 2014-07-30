class Question < ActiveRecord::Base
  attr_accessor :selection, :user_weight, :question_type, :user_responses, :movie_scores

  def self.weight
    {
      "I don't care" => 0,
      "I care a little" => 1,
      "I care so much it hurts" => 2
    }
  end

  def add_to_user_responses
    self.user_responses ||= {}
    self.user_responses[self.question_type] = [self.selection, self.user_weight]
  end

  def selection
    if @selection.is_a?(Array)
      @selection.pop
      sel = @selection.map {|s| s.to_i }
    end
    return sel
  end

  def find_my_movies
    score_sum = []
    user_genre_ids = user_responses["genres"].first
    user_genre_weight = user_responses["genres"].last.to_i
    Movie.all.each do |m|
      intersection = m.genres.pluck(:id) & user_genre_ids
      g_score = intersection.count.to_f / m.genres.pluck(:id).count
      if user_genre_weight == 1
        score_sum << Math.sqrt(g_score)
      elsif user_genre_weight == 2
        score_sum << g_score
      end
      self.movie_scores ||= {}
      self.movie_scores[m.title] = score_sum.inject {|sum, elem| sum + elem } / score_sum.size unless score_sum == []
    end
  end

end
