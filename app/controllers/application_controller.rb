class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  rescue_from Apipie::ParamMissing, with: :render_parameters_error

  protected
  def render_parameters_error(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
