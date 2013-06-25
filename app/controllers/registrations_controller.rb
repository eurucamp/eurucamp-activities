class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!, only: :create
  skip_before_filter :clean_up_session, only: [:new, :create]

  helper_method :during_oauth_flow?

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_without_password(editable_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  private

    def during_oauth_flow?
      !current_user && @user.new_record? && session[:omniauth].present?
    end

    def build_resource(*args)
      super.tap do |user|
        if user && session[:omniauth]
          user.apply_omniauth(session[:omniauth])
          user.valid?
        end
      end
    end

    def after_update_path_for(resource)
      edit_user_registration_path
    end

    def sign_up_params
      editable_params
    end

    def editable_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
