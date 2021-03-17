class Tag < ApplicationRecord
    has_and_belongs_to_many :tweets
    #belongs_to :tweet
end
