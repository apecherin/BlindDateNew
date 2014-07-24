class PagesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end
end
