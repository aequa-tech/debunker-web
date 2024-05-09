class ApplicationController < ActionController::Base
  layout 'application'

  before_action :set_user

  private

  def after_sign_in_path_for(_resource)
    user_root_path
  end

  def set_user
    @user = current_user
  end
end
