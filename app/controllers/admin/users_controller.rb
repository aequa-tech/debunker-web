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
      if params[:available_tokens].to_i > user.available_tokens
        add_token_to_user(user)
      else
        token_to_destroy = user.available_tokens - params[:available_tokens].to_i
        user.tokens.last(token_to_destroy).each(&:destroy)
      end
    end

    def add_tokens_to_user(user)
      token_to_generate = params[:available_tokens].to_i - user.available_tokens
      user.generate_call_tokens(token_to_generate)
    end

    def remove_tokens_from_user(user)
      token_to_destroy = user.available_tokens - params[:available_tokens].to_i
      user.tokens.last(token_to_destroy).each(&:destroy)
    end
  end
end
