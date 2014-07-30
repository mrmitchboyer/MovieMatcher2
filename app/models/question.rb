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

  def find_my_movies
    
  end

end
