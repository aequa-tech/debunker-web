# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      super do |resource|
        if resource.errors.empty?
          resource.generate_api_key
          resource.generate_free_call_tokens
        end
      end
    end
  end
end
