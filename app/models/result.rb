class Result < ActiveRecord::Base
  belongs_to :record
  has_many :comparisons
end
