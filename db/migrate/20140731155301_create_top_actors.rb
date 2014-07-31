class CreateTopActors < ActiveRecord::Migration
  def change
    create_table :top_actors do |t|
      t.string :name

      t.timestamps
    end
  end
end
