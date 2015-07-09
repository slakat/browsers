class Record < ActiveRecord::Base
  has_many :primary_records, :class_name => "relation", :foreign_key => "record_a_id"
  has_many :secondary_records, :class_name => "relation", :foreign_key => "record_b_id"
  has_many :results
end
