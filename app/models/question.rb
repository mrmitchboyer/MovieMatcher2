class Question < ActiveRecord::Base
  attr_accessor :selection, :user_weight, :question_type, :user_responses

  def self.weight
    {
      "I don't care" => 0,
      "I care a little" => 1,
      "Whatever" => 2,
      "I care a decent amount" => 3,
      "I care so much it hurts" => 4
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
    user_genre_ids = user_responses["genres"].first
    user_genre_weight = user_responses["genres"].last
    Movie.all.each do |m|
      intersection = m.genres.pluck(:id) & user_genre_ids
      raise "#{m.title}: #{m.genres.pluck(:id)}, #{user_genre_ids} #{intersection}"
    end
  end

end
