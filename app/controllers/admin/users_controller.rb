module Admin
  class UsersController < AuthenticatedController
    include Pagy::Backend

    def index
      @pagy, @users = pagy(User.all)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
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
              :role,
              api_keys_attributes: %i[
                id
                updated_at
                available_tokens_number
              ]
            )
    end
  end
end
