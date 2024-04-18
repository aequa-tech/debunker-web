module Admin
  class UsersController < ApplicationController
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
        redirect_to admin_users_path, notice: 'User was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: 'User was successfully destroyed.'
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
