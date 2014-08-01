class AddTicketAndTrailerToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :ticket, :string
    add_column :movies, :trailer, :string
  end
end
