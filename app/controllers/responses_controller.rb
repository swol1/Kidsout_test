class ResponsesController < ApplicationController
  before_action :ensure_logged_in

  def create
    Announcement.transaction do
      @announcement = Announcement.active.find(params[:announcement_id])

      @user_response = @announcement.responses.create(response_params)
      @user_response.user = current_user

      @user_response.save
    end

    if @user_response.persisted?
      render json: @user_response
    else
      render json: @user_response.errors, status: :unprocessable_entity
    end
  end

  def cancel
    Announcement.transaction do
      @announcement = Announcement.active.find(params[:announcement_id])
      @user_response = @announcement.responses.find(params[:id])

      @user_response.update(status: :cancelled)
    end

    render json: @user_response
  end

  def accept
    Announcement.transaction do
      @announcement = current_user.announcements.find(params[:announcement_id])
      @user_response = @announcement.responses.find(params[:id])

      @announcement.update(status: :closed)
      @announcement.responses.update_all(status: :declined)
      @user_response.update(status: :accepted)
    end

    render json: @user_response
  end

  private

  def response_params
    params.require(:response).permit(:price)
  end
end
