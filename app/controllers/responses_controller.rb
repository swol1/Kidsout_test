class ResponsesController < ApplicationController
  before_action :ensure_logged_in

  def create
    user_response =
      CreateResponseService.new(params[:announcement_id], response_params, current_user).call
    json_response = ResponseBlueprint.render user_response

    if user_response.persisted?
      render json: json_response
    else
      render json: user_response.errors, status: :unprocessable_entity
    end
  end

  def cancel
    user_response = CancelResponseService.new(params[:announcement_id], params[:id]).call
    json_response = ResponseBlueprint.render user_response

    render json: json_response
  end

  def accept
    user_response = AcceptResponseService.new(params[:announcement_id], params[:id], current_user).call
    json_response = ResponseBlueprint.render user_response

    render json: json_response
  end

  private

  def response_params
    params.require(:response).permit(:price)
  end
end
