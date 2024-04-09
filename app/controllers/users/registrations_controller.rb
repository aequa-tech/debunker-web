module Users
  class RegistrationsController < Devise::RegistrationsController
    def update_password
      @user = current_user
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      user_updated = update_resource(@user, account_update_params)
      if user_updated
        set_flash_message_for_update(@user, prev_unconfirmed_email)
        bypass_sign_in @user, scope: resource_name if sign_in_after_change_password?
        respond_with @user, location: after_update_path_for(@user)
      else
        clean_up_passwords @user
        set_minimum_password_length
        render :edit_password, status: :unprocessable_entity
      end
    end

    def edit_password
      @user = current_user
    end

    protected

    def sign_up_params
      params.require(:user)
            .permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user)
            .permit(:name, :email, :password, :password_confirmation, :current_password)
    end

    def update_resource(resource, params)
      if params.key?(:password) || params.key?(:password_confirmation)
        resource.update_with_password(params)
      else
        resource.update(params.except(:password, :password_confirmation, :current_password))
      end
    end
  end
end
