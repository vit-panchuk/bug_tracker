class AdminController < ApplicationController
  def login
  end

  def logined
  	if m = Manager.authenticate(params[:login], params[:password])
  		session[:manager_id] = m.id
  		redirect_to tickets_url
		else
			session[:manager_id] = nil
			redirect_to login_url, alert: 'Wrong login or password'
		end
  end

  def logout
    session[:manager_id] = nil
    redirect_to root_path
  end
end
