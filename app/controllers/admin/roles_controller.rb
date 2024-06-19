# frozen_string_literal: true

module Admin
  class RolesController < AuthenticatedController
    include Pagy::Backend

    def index
      @pagy, @roles = pagy(Role.order(:id).all)
    end
  end
end
