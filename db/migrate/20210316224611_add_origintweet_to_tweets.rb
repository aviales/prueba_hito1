class AddOrigintweetToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :origin_tweet, :integer
  end
end
