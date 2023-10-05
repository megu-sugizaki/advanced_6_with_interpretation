class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    # 現在ログインしているユーザーの、favoriteモデルに対して、アソシエーションで紐づけたbook_idの中の今引っ張ってきている@book.idに対していいねを作成するという記述
    # もともとの解答は「@favorite = current_user.favorites.new(book_id: book.id)」という記載だった（上の@bookもローカル変数になっており、下のfavoriteはインスタンス変数だった）→記述の意味は同じ。
    # ただし、今のように書いた方がshowページとの統一性がとれていてわかりやすいコードになっている。
   
    favorite.save
    render 'replace_btn'
    # 非同期通信を行ったので、replaceのjs.erbファイルを参照するようにrender先を設定。js.erbファイルでインスタンス変数を定義している。
  end

  def destroy
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: book.id)
    # find_byはfindと違い、最初にヒットした1つのみを返す。findは引数にidしかとらないのに対し、find_byはidでもid以外の情報でも探すことができる。→このほかに使用する具体的な例や違いはいまいち
    @favorite.destroy
    render 'replace_btn'
  end
end
