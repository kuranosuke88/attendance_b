class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforeフィルタ
  
  # ユーザーid取得
  
  def set_user
    @user = User.find(params[:id])
  end
  
  # ログイン済ユーザーか確認
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  # アクセスしたユーザーが現在ログインしているか確認
  
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # システム管理権限者判定
  
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
 # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
  def set_one_week
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_week : params[:date].to_date
    @last_day = @first_day.end_of_week
    one_week = [*@first_day..@last_day]
    
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless one_week.count == @attendances.count
      ActiveRecord::Base.transaction do
      one_week.each { |day| @user.attendances.create!(worked_on: day) }
      end
    end
    
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました。再アクセスしてください。"
    redirect_to root_url
  end
end