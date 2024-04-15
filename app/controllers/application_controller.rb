class ApplicationController < ActionController::Base
  layout 'application'

  before_action :authenticate_user!
  before_action :set_user

  private

  def set_user
    @user = current_user
  end
end
