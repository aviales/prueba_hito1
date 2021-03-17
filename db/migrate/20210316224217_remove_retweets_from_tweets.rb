class RemoveRetweetsFromTweets < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweets, :retweets, :integer
  end
end
