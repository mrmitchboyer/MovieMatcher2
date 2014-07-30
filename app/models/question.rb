class Question < ActiveRecord::Base
  attr_accessor :selection, :user_weight

  def self.weight
    {
      "I don't care" => 0,
      "I care a little" => 1,
      "Whatever" => 2,
      "I care a decent amount" => 3,
      "I care so much it hurts" => 4
    }
  end

  def find_my_movies
    
  end

end
