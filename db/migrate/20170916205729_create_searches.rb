class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :q
      t.integer :time

      t.timestamps null: false
    end
  end
end
