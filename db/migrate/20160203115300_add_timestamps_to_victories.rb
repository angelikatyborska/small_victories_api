class AddTimestampsToVictories < ActiveRecord::Migration
  def change
    add_column :victories, :created_at, :datetime
    add_column :victories, :updated_at, :datetime
  end
end
