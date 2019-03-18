class ApplicationController < ActionController::API
  private

  def current_user
    @current_user ||= User.find(request.headers["HTTP_X_USER_ID"])
  end

  def ensure_logged_in
    render json: { user_id: "must be present" }, status: 400 unless current_user
  end
end
