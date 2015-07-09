class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :position
      t.string :title
      t.string :link
      t.text :snippet
      t.references :record, index: true

      t.timestamps null: false
    end
    add_foreign_key :results, :records
  end
end
