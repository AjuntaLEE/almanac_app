require 'digest'
class User < ActiveRecord::Base
	attr_accessor :password, :password_confirmation
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_validation :encrypt_password

  before_create :create_remember_token

	validates :name, presence: true, length: {maximum: 45}
	
	validates :email, presence: true, 
					format:  { with: VALID_EMAIL_REGEX },
					uniqueness: { case_sensitive: false }
	validates :password, :presence => true,
                       :length => { :within => 6..40 }
  validates :password_digest, :presence   => true

  before_save { self.email = email.downcase }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypttoken(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

	def self.authenticate(email, submitted_password)
  	user = find_by_email(email)
  	return nil  if user.nil?
  	return user if user.has_password?(submitted_password)
	end

	# Return true if the user's password matches the submitted password.
	def has_password?(submitted_password)
	# Compare password_digest with the encrypted version of
	# submitted_password.
		self.password_digest == encrypt(submitted_password)
	end

  def promote
    self.admin = true
  end

  def demote
    self.admin = false
  end

  def accredit
    self.accrediteduser = true
  end

  def discredit
    self.accrediteduser = false
  end

  private

    def encrypt_password
      puts "encryption password_digest "
      self.salt = make_salt unless has_password?(password)
      if secure_hash("#{self.password}") == secure_hash("#{password_confirmation}")
        self.password_digest = encrypt(password)
      else 
        self.password_digest = ""
      end
    end

    def encrypt(string)
      puts "encryption core"
      return secure_hash("#{self.salt}--#{string}")
    end

    def make_salt
      puts "salt generation"
      return secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      puts "generating secure hash"
      return Digest::SHA2.hexdigest(string)
    end

    def create_remember_token
      self.remember_token = User.encrypttoken(User.new_remember_token)
    end

end
