class Result < ActiveRecord::Base
  belongs_to :record
  has_many :comparisons
  has_many :similarities
end
