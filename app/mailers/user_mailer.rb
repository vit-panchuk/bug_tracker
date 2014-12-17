class UserMailer < ActionMailer::Base
  default from: "support@gbugtracker.com"

  # smtp.gmail settings are in /config/initializers/setup_mail.rb

  def send_notification(ticket)
    @ticket = ticket
    mail to: "#{@ticket.name} <#{@ticket.email}>", subject: "Issue Ticket Notification: #{@ticket.subject}"
  end

  def send_reply(reply)
  	@reply = reply
  	@ticket = @reply.ticket
  	mail to: "#{@ticket.name} <#{@ticket.email}>", subject: "New Reply: #{@ticket.subject}"
  end
end
