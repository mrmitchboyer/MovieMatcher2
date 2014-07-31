class CreateTopDirectors < ActiveRecord::Migration
  def change
    create_table :top_directors do |t|
      t.string :name

      t.timestamps
    end
  end
end
