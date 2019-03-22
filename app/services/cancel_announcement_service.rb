class CancelAnnouncementService
  def initialize(id, current_user)
    @id = id
    @current_user = current_user
  end

  def call
    Announcement.transaction do
      announcement = @current_user.announcements.lock("FOR UPDATE").find(@id)

      announcement.responses.update_all(status: :declined)
      announcement.tap { |ann| ann.update(status: :cancelled) }
    end
  end
end