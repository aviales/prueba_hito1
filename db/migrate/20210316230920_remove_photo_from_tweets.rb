class RemovePhotoFromTweets < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweets, :photo, :string
  end
end
