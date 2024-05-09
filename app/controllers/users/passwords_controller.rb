# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    def create
      super do
        if @resource.blank?
          return redirect_to new_user_session_path, notice: I18n.t('devise.passwords.send_paranoid_instructions')
        end
      end
    end
  end
end
