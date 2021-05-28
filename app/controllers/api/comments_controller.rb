class Api::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
     comment = current_user.comments.create(params.permit(:article_id, :body))
     if comment.persisted?
     render json: { message: 'Your comment has been published'}, status: 201
     else 
      render json: { error_message: 'Comment can\'t be empty'}, status: 422
     end
  end  
end
