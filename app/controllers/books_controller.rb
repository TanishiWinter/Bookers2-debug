class BooksController < ApplicationController

  before_action :is_matching_login_user, only: [:update, :edit]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    unless ReadCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.read_counts.create(book_id: @book.id)
    end

    @user = @book.user_id
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user)
    if @user == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    if params[:latest]
      @books = Book.latest
    elsif params[:star_count]
      @books = Book.star_count
    else
       to  = Time.current.at_end_of_day
       from  = (to - 6.day).at_beginning_of_day
       @books = Book.all.sort {|a,b|
         b.favorites.where(created_at: from...to).size <=>
         a.favorites.where(created_at: from...to).size
       }
    @book = Book.new
    end

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice:  "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end


  private

  def book_params
    params.require(:book).permit(:title, :body, :image, :star, :category)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    if(book.user_id != current_user.id)
      redirect_to books_path
    end
  end

end
