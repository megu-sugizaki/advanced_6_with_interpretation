class UsersController < ApplicationController
  before_action :authenticate_user!
  # ログインしていない限り見られないページ
  before_action :ensure_correct_user, only: [:edit, :update]
   # 今ログインしているのが@bookのuser（特定のbookのidを探して、そのbook_idのuser(user_id)）でない限りは編集、削除ができない

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    # Userモデルにある全てのカラムを表示するためのインスタンス。
    @book = Book.new
    # bookの新規作成viewを入れたいので、Book.newを定義。
  end

  def edit
  end

  def update
    if @user.update(user_params)
      # @userの定義なし？おそらく@user = User.find(params[:id])。何をupdateするかというと、user_params = userのname, introduction, profile_image
      redirect_to user_path(@user), notice: "You have updated user successfully."
      # user_pathはuserのshowページ。その中で、特定のuser.idを持つuserのshowページに移動。
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
    # userモデルの中からname, introduction, profile_image用に箱を提供するための定義。この3つしか変更できないように設定。
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  # Userの中から特定のuserを探して、そのuserが現在ログインしているuserじゃなければログインしているuserのshowページに移動するように。
end
