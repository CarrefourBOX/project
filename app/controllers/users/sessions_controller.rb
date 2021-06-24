# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  prepend_before_action :require_no_authentication, only: [:new]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
    # super
  # end
  
  # POST /resource/sign_in
  def create
    respond_to do |format|
      if warden.authenticate(auth_options).nil?
        format.turbo_stream do
          flash.now[:alert] = 'Credenciais inválidas'
          render turbo_stream: turbo_stream.replace(:alerts, partial: 'shared/flashes')
        end
      else
        format.html { super }
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
