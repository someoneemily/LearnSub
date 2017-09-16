class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :topics
      t.integer :time
      # t.text :interested
      t.timestamps null: false
    end
  end
end
