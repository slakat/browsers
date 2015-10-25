class Relation < ActiveRecord::Base
  belongs_to :record_a, :class_name => 'Record'
  belongs_to :record_b, :class_name => 'Record'
  has_many :comparisons

end
