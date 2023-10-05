class BooksController < ApplicationController
  before_action :authenticate_user!
  # ログインしていない限り見られないページ
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  # 今ログインしているのが@bookのuser（特定のbookのidを探して、そのbook_idのuser(user_id)）でない限りは編集、削除ができない

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @books = Book.all
    @book = Book.new
    # indexページにnewのviewを作るので、Book.newの記載が必要
  end

  def create
    @book = Book.new(book_params)
    # createアクションで新しいbookを作ったら、そのデータを入れる箱（params)が必要になる。なので、praivate以下にbook_paramsを定義してその箱を作ってあげる。
    @book.user_id = current_user.id
    # user_idはuserモデルを作成した際に自動でできるid。current_userに関しては自動でできたものがないので、.idとつける。アソシエーションしているからuserモデルのidがここに記載できると思われる。
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
      # book_pathはshowページへのpath。@bookとつけるのは、showページの中の今作ったbook = @bookに戻したいから。
    else
      @books = Book.all
      # indexに飛ばしたいけれども、renderだと定義などがすっ飛んでしまう。なので、@booksでもう一回定義する。
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      # @book = Book.find(@arams[:id])の記載が抜けているが、問題なさそう。
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
