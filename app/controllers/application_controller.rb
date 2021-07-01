class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :persist_last_visited_path, except: %i[create update]

  # Uncomment if user model has additional attributes
  # before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(root_path)
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[login email first_name last_name cpf phone birth_date]
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login encrypted_password]
  end

  # def after_sign_in_path_for(resource)
  #   request.referrer || root_path
  # end

  def persist_last_visited_path
    return if Rails.configuration.ignored_paths.include?(request.path) || request.xhr?

    session[:last_visited_path] = request.path
  end

  def after_sign_in_path_for(_resource)
    if session[:last_visited_path].present?
      session[:last_visited_path]
    else
      start_path
    end
  end
end
