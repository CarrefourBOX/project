class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
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
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name cpf phone birth_date])
  end
  
  # Uncomment and add keys if user model has additional attributes
  # def configure_permitted_parameters
  #   # For additional fields in app/views/devise/registrations/new.html.erb, e.g. "username"
  #   devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
  
  #   # For additional fields in app/views/devise/registrations/edit.html.erb, e.g. "username"
  #   devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
  # end
end
