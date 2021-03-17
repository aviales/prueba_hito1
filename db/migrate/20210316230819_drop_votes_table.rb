class DropVotesTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :votes do |t|
      t.string :votable_type, null: false
      t.integer :votable_id, null: false
      t.string :voter_type, null: false
      t.integer :voter_id, null: false
      t.boolean :vote_flag, null: false
      t.string :vote_scope, null: false
      t.integer :vote_weight, null: false
      t.timestamps null: false
    end
  end
end
