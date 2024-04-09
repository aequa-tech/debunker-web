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
        update_available_tokens(@user)
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
      params.require(:user).permit(:available_tokens, :role)
    end

    def update_available_tokens(user)
      if user_params[:available_tokens].to_i > user.available_tokens.count
        add_tokens_to_user(user)
      else
        remove_tokens_from_user(user)
      end
    end

    def add_tokens_to_user(user)
      token_to_generate = user_params[:available_tokens].to_i - user.available_tokens.count
      user.generate_call_tokens(token_to_generate)
    end

    def remove_tokens_from_user(user)
      token_to_destroy = user.available_tokens.count - user_params[:available_tokens].to_i
      user.available_tokens.last(token_to_destroy).each(&:destroy)
    end
  end
end
