class AnnouncementsController < ApplicationController
  before_action :ensure_logged_in, except: %i[index]

  def index
    @announcements = Announcement.active

    render json: @announcements
  end

  def show
    @announcement = current_user.announcements.includes(:responses).find(params[:id])

    render json: @announcement.as_json(include: :responses)
  end

  def create
    @announcement = current_user.announcements.create(announcement_params)

    if @announcement.save
      render json: @announcement
    else
      render json: @announcement.errors, status: :unprocessable_entity
    end
  end

  def cancel
    CancelAnnouncementService.new(params[:id], current_user).call

    render json: @announcement
  end

  private

  def announcement_params
    params.require(:announcement).permit(:description)
  end
end
