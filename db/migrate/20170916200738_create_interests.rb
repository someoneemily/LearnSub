class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :topics
      t.integer :time

      t.timestamps null: false
    end
  end
end
