class AcceptResponseService
  def initialize(announcement_id, id, current_user)
    @announcement_id = announcement_id
    @id = id
    @current_user = current_user
  end

  def call
    Announcement.transaction do
      announcement = @current_user.announcements.lock("FOR UPDATE").find(@announcement_id)
      user_response = announcement.responses.find(@id)

      announcement.update(status: :closed)
      announcement.responses.update_all(status: :declined)
      user_response.tap { |u| u.update(status: :accepted) }
    end
  end
end