class AnnouncementsController < ApplicationController
  before_action :ensure_logged_in, except: %i[index]

  def index
    announcements =
      AnnouncementBlueprint.render Announcement.active, view: :normal

    render json: announcements
  end

  def show
    announcement =
      AnnouncementBlueprint.render current_user.announcements.includes(:responses).find(params[:id]),
                                   view: :extended

    render json: announcement
  end

  def create
    user_announcement = current_user.announcements.create(announcement_params)
    announcement = AnnouncementBlueprint.render user_announcement, view: :normal

    if user_announcement.save
      render json: announcement
    else
      render json: user_announcement.errors, status: :unprocessable_entity
    end
  end

  def cancel
    user_announcement = CancelAnnouncementService.new(params[:id], current_user).call
    announcement = AnnouncementBlueprint.render user_announcement, view: :normal

    render json: announcement
  end

  private

  def announcement_params
    params.require(:announcement).permit(:description)
  end
end
