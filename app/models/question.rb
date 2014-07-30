class Question < ActiveRecord::Base
  attr_accessor :text, :selection

  def self.weight
    {
      "I don't care" => 0,
      "I care a little" => 1,
      "Whatever" => 2,
      "I care a decent amount" => 3,
      "I care so much it hurts" => 4
    }
  end

end
