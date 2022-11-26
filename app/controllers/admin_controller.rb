class AdminController < ApplicationController

    def index
        @users = User.all
    end

    def toggle_account_status
        @user = User.find(params[:id])
        @user.update(is_active: !@user.is_active)
        redirect_to admin_path_url and return
    end

    def toggle_account_admin
        @user = User.find(params[:id])
        @user.update(admin: !@user.admin)
        redirect_to admin_path_url and return
    end

end
