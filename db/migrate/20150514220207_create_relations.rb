class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :record_a_id, index: true
      t.integer :record_b_id, index: true
      t.string :search
      t.datetime :time_a
      t.datetime :time_b

      t.timestamps null: false
    end
  end
end
