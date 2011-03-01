class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :authenticate_user!
	rescue_from CanCan::AccessDenied do |exception|
		flash[:notice] = exception.message
		redirect_to :back,:flash => params[:flash]
	end
#
#	# For Ajax redirection it opens in modal box
	def redirect_to(options = {}, response_status = {})
		if request.xhr?
			render(:update) {|page| page.redirect_to(options)}
		else
			super(options, response_status)
		end
	end
end
