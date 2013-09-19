class ChatsController < ApplicationController
  before_filter :authenticate_user!
  def room
  end
end
