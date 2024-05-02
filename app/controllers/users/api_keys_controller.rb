# frozen_string_literal: true

module Users
  class ApiKeysController < ApplicationController
    include Pagy::Backend

    def index
      @pagy, @api_keys = pagy(@user.api_keys.order(expired_at: :desc))
    end

    def create
      @key_pair = ApiKey.generate_key_pair
      @api_key = ApiKey.new(@key_pair)

      if @user.api_keys.create(@key_pair)
        flash[:notice] = t('users.api_keys.notices.created')
        render :show, status: :ok
      else
        redirect_to root_path, alert: t('users.api_keys.notices.error')
      end
    end

    def destroy
      @api_key = @user.api_keys.find(params[:id])
      @api_key.expire!

      if @api_key.expired?
        flash[:notice] = t('users.api_keys.notices.expired')
        redirect_to users_api_keys_path
      else
        redirect_to users_api_keys_path, alert: t('users.api_keys.notices.error')
      end
    end
  end
end
