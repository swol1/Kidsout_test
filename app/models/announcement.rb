class Announcement < ApplicationRecord
  belongs_to :user
  has_many :responses

  validates :description, length: { maximum: 1000 }, presence: true

  before_create :set_status

  scope :active, -> { where(status: :active) }

  private

  def set_status
    self.status = :active
  end
end
