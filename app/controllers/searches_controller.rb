class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]


    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      render "/searches/search_result"
    elsif @range == "Book"
      @books = Book.looks(params[:search], params[:word])
      render "/searches/search_result"
    elsif @range == "Tag"
      @books = Book.where("category LIKE?","%#{@word}%")
      render "/searches/search_result"
    end
  end

end
