class ApplicationController < ActionController::Base
  layout 'application'

  before_action :authenticate_user!
end
