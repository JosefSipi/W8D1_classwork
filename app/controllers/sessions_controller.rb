class SessionsController < ApplicationController



    before_action :ensuer_logged_in only: [:destroy]
    
    def new
        render :new
    end

    def create
        @user = User.find_by_cridentials(username: params[:user][:username], password: params[:user][:password])

        if @user
            login!(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    def destroy
        logout!
        redirect_to new_session_url
    end


end