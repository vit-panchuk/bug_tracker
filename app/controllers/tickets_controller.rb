class TicketsController < ApplicationController
  # GET /tickets
  # GET /tickets.json
  def index
    raise ActionController::RoutingError.new('Not Found') unless session[:manager_id]
    @tickets = case params[:stats]
    when Ticket::STAFF_STATS[:new_unassigned_tickets]
      Ticket.where(manager_id: nil)
    when Ticket::STAFF_STATS[:open_tickets]
      Ticket.where(stats: [Ticket::STATS[:waiting_for_staff_response], Ticket::STATS[:waiting_for_customer]]).where('manager_id is not null')
    when Ticket::STAFF_STATS[:on_hold_tickets]
      Ticket.where(stats: Ticket::STATS[:on_hold])
    when Ticket::STAFF_STATS[:closed_tickets]
      Ticket.where(stats: [Ticket::STATS[:completed], Ticket::STATS[:cancelled]])
    else
      Ticket.all  
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tickets }
    end
  end

  def search
    raise ActionController::RoutingError.new('Not Found') unless session[:manager_id]
    @tickets = Ticket.where(['`key` = ? OR `subject` = ?', params[:search], params[:search]])
    @search = true
    render 'index'
  end

  def index_by_email
    @tickets = Ticket.where(email: params[:email])  
    render 'index'
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @ticket = Ticket.find(params[:id])
    @reply = Reply.new(ticket_id: @ticket.id) if session[:manager_id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket }
    end
  end

  def show_by_key
    @ticket = Ticket.where(key: params[:key]).first
    @reply = Reply.new(ticket_id: @ticket.id) if session[:manager_id]
    if @ticket.stats == Ticket::STATS[:unconfirmed]
      @ticket.stats = Ticket::STATS[:waiting_for_staff_response]
      @ticket.save
    end

    render action: 'show'
  end

  def create_reply
    raise ActionController::RoutingError.new('Not Found') unless session[:manager_id]
    @reply = Reply.new(params[:reply])
    @reply.manager_id = session[:manager_id]
    ticket = @reply.ticket
    if @reply.save
      ticket.stats = @reply.stats
      ticket.manager_id = @reply.manager_id
      ticket.save
      UserMailer.send_reply(@reply).deliver! # smtp.gmail settings are in /config/initializers/setup_mail.rb
      redirect_to key_path(ticket.key), notice: 'Reply was successfully created.'
    else
      render action: 'show'
    end
  end

  # GET /tickets/new
  # GET /tickets/new.json
  def new
    @ticket = Ticket.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ticket }
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.stats = Ticket::STATS[:unconfirmed]
    
    respond_to do |format|
      if @ticket.save
        UserMailer.send_notification(@ticket).deliver! # smtp.gmail settings are in /config/initializers/setup_mail.rb
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created. Check your mailbox and confirm it.' }
        format.json { render json: @ticket, status: :created, location: @ticket }
      else
        format.html { render action: "new" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.json
  def update
    @ticket = Ticket.find(params[:id])
    @ticket.stats = Ticket::STATS[:waiting_for_staff_response]

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to tickets_url }
      format.json { head :no_content }
    end
  end
end
