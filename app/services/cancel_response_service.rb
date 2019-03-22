class CancelResponseService
  def initialize(announcement_id, id)
    @announcement_id = announcement_id
    @id = id
  end

  def call
    Announcement.transaction do
      announcement = Announcement.active.lock("FOR SHARE").find(@announcement_id)
      user_response = announcement.responses.find(@id)

      user_response.tap { |u| u.update(status: :cancelled) }
    end
  end
end