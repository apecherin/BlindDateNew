class PagesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @user = User.find(post_params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

private
  def post_params
    parameters = params.permit(:id)
  end
end
