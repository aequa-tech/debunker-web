module Admin
  class DashboardController < AuthenticatedController
    def index
      redirect_to admin_users_path
    end
  end
end
