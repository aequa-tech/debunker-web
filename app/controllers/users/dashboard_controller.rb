module Users
  class DashboardController < ApplicationController
    def index
      # The `current_user` method is provided by Devise and returns the currently signed-in user
      @user = current_user
    end
  end
end
