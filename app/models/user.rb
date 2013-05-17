# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :photo, :delete_photo
  attr_accessor :new_password, :new_password_confirmation
  validates_confirmation_of :new_password, :if=>:password_changed?
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_attached_file :photo,
      :styles => {
      :thumb  => "100x100#",
      :small  => "65x65",
      :large  => "450x450>",
      :url    => "/images/:attachment/:id_:style.:extension",
      :path   => ":rails_root/app/assets/images/:attachment/:id_:style.:extension" }

  #validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  before_save :hash_new_password, :if=>:password_changed?
  before_save { email.downcase! }
  before_save :create_remember_token
  before_validation :clear_photo

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  def password_changed?
    !@new_password.blank?
  end

  def self.authenticate(email, password)
    if user = find_by_email(email)
      if BCrypt::Password.new(user.password).is_password? password
        return user
      end
    end
    return nil
  end

   def delete_photo=(value)
    @delete_photo = !value.to_i.zero?
  end
  
  def delete_photo
    !!@delete_photo
  end
  alias_method :delete_photo?, :delete_photo

  def clear_photo
    self.photo = nil if delete_photo? && !photo.dirty?
  end


  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def hash_new_password
      self.password = BCrypt::Password.create(@new_password)
    end
end