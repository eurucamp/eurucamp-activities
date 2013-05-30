class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!, only: :create

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(params)
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

    def build_resource(*args)
      super.tap do |user|
        if user && session[:omniauth]
          user.apply_omniauth(session[:omniauth])
          user.valid?
        end
      end
    end

    def update_resource(params)
      if resource.no_oauth_connected?
        paramz = params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
        resource.update_with_password(paramz)
      else
        paramz = params.require(:user).permit(:name, :email)
        resource.update_without_password(paramz)
      end
    end

end
