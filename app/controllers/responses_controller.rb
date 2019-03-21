class ResponsesController < ApplicationController
  before_action :ensure_logged_in

  def create
    @user_response =
      CreateResponseService.new(params[:announcement_id], response_params, current_user).call

    if @user_response.persisted?
      render json: @user_response
    else
      render json: @user_response.errors, status: :unprocessable_entity
    end
  end

  def cancel
    CancelResponseService.new(params[:announcement_id], params[:id]).call

    render json: @user_response
  end

  def accept
    AcceptResponseService.new(params[:announcement_id], params[:id], current_user).call

    render json: @user_response
  end

  private

  def response_params
    params.require(:response).permit(:price)
  end
end
