module Users
  class DashboardController < ApplicationController
    def index
      @current_api_key = @user.api_keys.active.last
    end
  end
end
