class CreateDirtyMatches < ActiveRecord::Migration
  def change
    create_table :dirty_matches do |t|
      t.integer :match_counts
      t.integer :segment, index: true
      t.references :relation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
