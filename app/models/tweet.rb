class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :tags
  #has_many :tags
  validates :content, presence: true
  # acts_as_votable

  delegate :profile_photo, to: :user, prefix: :true

  def add_like(user)
    Like.create(user: user, tweet: self)
  end

  def remove_like(user)
    Like.where(user: user, tweet: self).first.destroy
  end

  def original_tweet
    Tweet.find(self.origin_tweet)
  end

  after_create do
    #tweet = Tweet.find_by(id: self.id)
    hashtags = self.content.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      self.tags << tag 
    end
  end

  before_update do
    #tweet = Tweet.find_by(id: self.id)
    tweet.tags.clear
    hashtags = self.content.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      self.tags << tag 
    end
  end
end
