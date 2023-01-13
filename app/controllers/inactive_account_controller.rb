class InactiveAccountController < ApplicationController
    def index
        @admins = User.find_by_admin(true)
    end
end