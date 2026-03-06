class ApplicationController < ActionController::API
  before_action :authenticate_request

  rescue_from CanCan::AccessDenied do |e|
    render json: { error: "Access denied", message: e.message }, status: :forbidden
  end

  def current_user
    @current_user
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last
    return head :unauthorized unless token

    payload = JwtService.decode(token)
    return head :unauthorized unless payload

    @current_user = User.find_by(id: payload[:user_id])
    head :unauthorized unless @current_user
  end
end
