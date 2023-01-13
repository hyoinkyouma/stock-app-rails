class AdminController < ApplicationController
    before_action :check_admin

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

    private
    def check_admin
        if !current_user.admin?
            redirect_to "/"
        end
    end

end
