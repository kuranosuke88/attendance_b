class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def admin_login
     user = User.find(1)
    if user
      log_in user
      flash[:success] = '管理者でログインしました。'
      redirect_back_or user
    else
     flash.now[:danger] = '認証に失敗しました。'  
     render :new
    end
  end
  
  def general_login
     user = User.find(2)
    if user
      log_in user
      flash[:success] = '一般者でログインしました。'
      redirect_back_or user
    else
     flash.now[:danger] = '認証に失敗しました。'  
     render :new
    end
  end
  
  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました。"
    redirect_to root_url
  end
end
