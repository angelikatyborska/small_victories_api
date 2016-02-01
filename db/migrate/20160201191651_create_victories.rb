class CreateVictories < ActiveRecord::Migration
  def change
    create_table :victories do |t|
      t.text :body, null: false
      t.references :user, index: true, foreign_key: true, null: false
    end
  end
end
