class RemoveLikesFromTweets < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweets, :likes, :integer
  end
end
