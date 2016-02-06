class AddRatingToVictories < ActiveRecord::Migration
  def change
    add_column :victories, :rating, :integer, default: 0, null: false
  end
end
