class User < ActiveRecord::Base
	has_many :authentications
	has_many :roles_users,:dependent => :destroy
	has_many :roles,:through=>:roles_users
	has_many :events
	has_many :thoughts
	has_many :comments
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable, :lockable and :timeoutable
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me,:name

	def apply_omniauth(omniauth)
		self.email = omniauth['user_info']['email'] if email.blank?
		authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
	end

	def password_required?
		(authentications.empty? || !password.blank?) && super
	end

	def role?(role)
		return !!self.roles.find_by_name(role.to_s)
	end
	
end
