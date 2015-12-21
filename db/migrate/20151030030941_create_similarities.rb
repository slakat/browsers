class CreateSimilarities < ActiveRecord::Migration
  def change
    create_table :similarities do |t|
      t.integer :result_a_id, index: true
      t.integer :result_b_id, index: true
      t.boolean :same_content
      t.boolean :related_pages
      t.integer :relation_id, index: true
      t.string :error, index: true
      t.timestamps null: false
    end
  end
end
