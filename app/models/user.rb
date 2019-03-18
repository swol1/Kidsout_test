class User < ApplicationRecord
  has_many :announcements
  has_many :responses
end
