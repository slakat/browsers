class Relation < ActiveRecord::Base
  belongs_to :record_a, :class_name => 'Record'
  belongs_to :record_b, :class_name => 'Record'
  has_many :comparisons
  has_many :similarities
  has_one :perfect_match
  has_one :dirty_match
  has_one :all_match

end
