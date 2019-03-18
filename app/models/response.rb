class Response < ApplicationRecord
  belongs_to :announcement
  belongs_to :user

  # validates :user, uniqueness: { scope: :announcement_id }
  validates :price, presence: true, numericality: { only_integer: true }, inclusion: 100..10000
  validate :check_not_self_response, :check_not_duplicate

  before_create :set_status

  private

  def set_status
    self.status = :pending
  end

  def check_not_self_response
    errors.add(:user_id, "can't be self respond") if user_id == announcement.user_id
  end

  def check_not_duplicate
    duplicates = announcement.responses.where(user_id: user_id).where.not(status: :cancelled)
    duplicates = duplicates.where.not(id: id) if persisted?

    if duplicates.exists?
      errors.add(:status, "you have already responded")
    end
  end
end
