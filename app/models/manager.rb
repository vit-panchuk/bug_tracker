class Manager < ActiveRecord::Base
  attr_accessible :login, :password, :id
  validates :login, uniqueness: true
  has_many :tickets
  has_many :replies
  before_save :crypt_password
  require 'digest/md5'

  def self.authenticate(l, p)
  	require 'digest/md5'
  	manager = Manager.where(login: l).first
  	if Digest::MD5.hexdigest(p) == manager.password
  		manager
  	else
  		false
  	end
  end

private
	def crypt_password
		require 'digest/md5'
		self.password = Digest::MD5.hexdigest(password)
	end
end
