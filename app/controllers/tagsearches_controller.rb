class TagsearchesController < ApplicationController
  def serch
    @model = Book
    @word = params[:content]
    @books = Book.where("category LIKE?","%#{@word}%")
    render "tagsearches/tagsearch"
  end
end
