class BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    # 現在ログインしているユーザーの新しいbook_commentsテーブルを作成。その際、book_commentという箱（params）が必要。
    @comment.book_id = book.id
    # ローカル変数で探したbookのidのことを@comment.book_idと定義する
    @comment.save
  end

  def destroy
    @comment = BookComment.find(params[:id])
    # BookCommentモデルから該当のidを持つコメントを探す
    @comment.destroy
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
    # book_commentモデルでは、commentのみを運んで良いことにする。（その他はuser_idとbook_id。特に書き換えの必要はないので記載なし）
  end
end
