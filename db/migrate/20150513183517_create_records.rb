class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :search, index: true
      t.string :country, index: true
      t.string :browser, index: true
      t.datetime :dateprint, index: true
      t.string :rol, unique: true

      t.timestamps null: false
    end
  end
end
