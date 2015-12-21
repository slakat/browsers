class Like < ActiveRecord::Base
  belongs_to :relation
  belongs_to :result_a, :class_name => 'Result'
  belongs_to :result_b, :class_name => 'Result'
end
