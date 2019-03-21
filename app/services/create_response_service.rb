class CreateResponseService
  def initialize(announcement_id, response_params, current_user)
    @announcement_id = announcement_id
    @response_params = response_params
    @current_user = current_user
  end

  def call
    Announcement.transaction do
      announcement = Announcement.active.lock("FOR SHARE").find(@announcement_id)

      user_response = announcement.responses.create(@response_params)
      user_response.user = @current_user
      user_response.tap(&:save)
    end
  end
end