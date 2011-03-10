class UserSessionsController < Devise::SessionsController

	def new

	end

	def create
    super
    unless session[:omniauth].nil?
	    current_user.authentications.create!(:provider => session[:omniauth]['provider'], :uid => session[:omniauth]['uid'].to_s)
	    session[:omniauth] = nil
    end

  end

	def destroy
		super
	end


end
