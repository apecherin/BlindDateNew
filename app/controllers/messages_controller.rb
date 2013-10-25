class MessagesController < ApplicationController
  before_filter :authenticate_user!
  def index
    #get all messages for current user
    @messages = Message.or({user_to: current_user.id}, {user_from: current_user.id}).order_by(:created_at => :desc)
    #get all users in messages
    @usrs_between = [] #group by user
    @messages.each do |message|
      @usrs_between << message.user_from
      @usrs_between << message.user_to
    end
    @usrs_between.uniq!
    @usrs_between.delete(current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  def show
    @messages = Message.or({user_to: params[:id], user_from: current_user.id}).or({user_to: current_user.id, user_from: params[:id]}).order_by
    #user will read all mess from this partner
    @messages.each do |message|
      message.update_attributes(is_read: true) if !message.is_read && message.user_to == current_user.id
    end
    @partner = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => { :messages=> @messages, :partner_id => @partner } }
    end
  end

  def new
    @message = Message.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(params[:message])
    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @message = Message.find(params[:id])
    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def getDialog
    messages = Message.or({user_to: params[:id], user_from: current_user.id}).or({user_to: current_user.id, user_from: params[:id]}).order_by
    render :json => { :messages => messages }
  end

  def addMessage
    status = false
    if current_user
      message = Message.new params[:message]
      status = message.save
    end
    render :json => { :success => status, :mess_id => message.id }
  end

  def countMessage
    new_messages = Message.and({user_to: current_user.id}, {is_read: false}).count()
    render :json => { :count => new_messages }
  end

  def readMessage
    message = Message.find(params[:id])
    status = message.update_attributes(is_read: true)
    render :json => { :success => status }
  end
end