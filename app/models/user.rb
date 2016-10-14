class User < ApplicationRecord
   has_many :microposts, dependent: :destroy
   has_many :active_relationships,  class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
   has_many :following, through: :active_relationships, source: :followed

   has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
   has_many :followers, through: :passive_relationships, source: :follower

   attr_accessor :remember_token, :activation_token, :reset_token
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

   # Creates reset digest
   def create_reset_digest
     self.reset_token = User.new_token
     self.update_attribute(:reset_digest, User.digest(reset_token))
     self.update_attribute(:reset_sent_at, Time.zone.now)
   end

   # Sends reset password email
   def send_password_reset_email
     UserMailer.password_reset(self).deliver_now
   end

   # Returns true if password expired (default after 2hrs)
   def password_reset_expired?
     reset_sent_at < 2.hours.ago
   end

   # Returns a user's feed
   def feed
     following_ids_subselect = "SELECT followed_id FROM relationships WHERE
                                followed_id = :user_id"
     Micropost.where("user_id IN (#{following_ids_subselect}) OR user_id = :user_id",
                      user_id: self.id)
   end

   # Follows a user.
   def follow(other_user)
     active_relationships.create(followed_id: other_user.id)
   end

   # Unfollows a user.
   def unfollow(other_user)
     active_relationships.find_by(followed_id: other_user.id).destroy
   end

   # Returns true if user is following another user
   def following?(other_user)
     self.following.include?(other_user)
     # or the longer more verbose version
     # !active_relationships.find_by(followed_id: other_user.id).nil?
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
