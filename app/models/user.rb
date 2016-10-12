class User < ApplicationRecord
   attr_accessor :remember_token, :activation_token
   before_save :downcase_email
   before_create :create_activation_digest

   validates :name, presence: true, length: { maximum: 50 }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[\w]+\z/i
   validates :email, presence: true, length: { maximum: 120 },
             format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false }

   has_secure_password
   validates :password, length: { minimum: 6 }, allow_blank: true

   # Returns the hash digest of the given string
   def User.digest(string)
     cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                   BCrypt::Engine.cost
     BCrypt::Password.create(string, cost: cost)
   end

   # Returns a random token
   def User.new_token
     SecureRandom.urlsafe_base64
   end

   # remembers a user in a database for use in persistent sessions.
   def remember
     self.remember_token = User.new_token
     update_attribute(:remember_digest, User.digest(remember_token))
   end

   # Forgets a user
   def forget
     update_attribute(:remember_digest, nil)
   end

   # Returns true if the given token matches the digest
   # ps. lookout for the BCrypt == which overrides the regular '==', thus '.' before rembm_token
   def authenticated?(attribute, token)
     digest = self.send("#{attribute}_digest")
     return false if digest.nil?
     BCrypt::Password.new(digest).is_password?(token)
   end

   # Activate an Account
   def activate
     self.update_attribute(:activated, true)
     self.update_attribute(:activated_at, Time.zone.now)
   end

   # Sends activation email
   def send_activation_email
     UserMailer.account_activation(self).deliver_now
   end


   private

   # Creates and assigns activation token to the user
   def create_activation_digest
     self.activation_token = User.new_token
     self.activation_digest = User.digest(activation_token)
   end

   # Converts email to all lower case
   def downcase_email
     self.email = email.downcase
   end
end
