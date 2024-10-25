# frozen_string_literal: true

module Admin
  class UsersController < AuthenticatedController
    include Pagy::Backend

    def index
      @pagy, @users = pagy(User.order(:id).all)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      @api_key = @user.api_keys.find_by(id: user_params[:api_keys_attributes]['0'][:id])
      @available_tokens_number = user_params[:api_keys_attributes]['0'][:available_tokens_number].to_i

      reloader = TokenReloader.new(@api_key)
      if @available_tokens_number > @api_key.available_tokens.count
        (@available_tokens_number - @api_key.available_tokens.count).times { reloader.regenerate_single_token }
      elsif @available_tokens_number < @api_key.available_tokens.count
        (@api_key.available_tokens.count - @available_tokens_number).times { @api_key.available_tokens.last.destroy }
      end

      if @api_key.available_tokens.count == @available_tokens_number && @user.update(role_id: user_params[:role_id])
        redirect_to admin_users_path, notice: I18n.t('admin.users.notices.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: I18n.t('admin.users.notices.deleted')
    end

    def revoke_api_key
      @user = User.find(params[:id])
      @api_key = @user.api_keys.find(params[:api_key_id])
      @api_key.expire!
      redirect_to edit_admin_user_path(@user), notice: I18n.t('admin.users.notices.api_key_revoked')
    end

    private

    def user_params
      params.require(:user)
            .permit(
              :role_id,
              api_keys_attributes: %i[
                id
                available_tokens_number
              ]
            )
    end
  end
end
