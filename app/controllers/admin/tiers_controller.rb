# frozen_string_literal: true

module Admin
  class TiersController < AuthenticatedController
    include Pagy::Backend

    def index
      @pagy, @tiers = pagy(Tier.order(:id).all)
    end
  end
end
