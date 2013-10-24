# == Schema Information
#
# Table name: users
#
#  id                      :integer       not null, primary key
#  username                :string(18)    not null
#  password_salt           :string(8)     not null
#  password_hash           :string(64)    not null
#  role_system_admin       :boolean       not null
#  role_claims_admin       :boolean       not null
#  role_claims_processing  :boolean       not null
#  role_payment_processing :boolean       not null
#  last_login_at           :datetime      
#  deleted                 :boolean       not null
#  show_name_address_csv   :boolean       not null
#

class User < ActiveRecord::Base
  # attr_accessible :username # all others protected !!
  attr_accessor :password, :password_confirm, :old_password  # fake columns 
  
  validates_uniqueness_of :username
  validates_length_of :username, :in => 4..18, :allow_nil => false
  
  @@cache_user = nil

  def password=(pass)
    @password=pass
    unless ( pass.blank? )
      salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
      self.password_salt, self.password_hash =  salt, Digest::SHA256.hexdigest(pass + salt)
    end
  end
  
  def validate
    unless ( self.password.blank? && self.password_confirm.blank?  ) 
      errors.add :password, 'Do not match' if self.password != self.password_confirm
      errors.add :password, 'is too short (minimum 6 characters)' if self.password.length < 6
      errors.add :password, 'must contain a number' unless (self.password =~ /[0-9]/)
   end
   errors.add :password, 'Is Required' if ( self.password.blank? && self.id.blank?  ) 
  end  
  
  def valid_password(pass)
     Digest::SHA256.hexdigest(pass + self.password_salt) == self.password_hash
  end

  def caption
    # Return heading for a patient
    if ( self.id.blank? )
      return "New User"
    end
    "#{self.username} [#{self.id}]"
  end 
  
  def after_save
    # clear the cache
    @@cache_user = nil
  end  
  
  # Save as User.find(id) - But caches last access 
  def self.cache(id)
    @@cache_user = self.find(id) if @@cache_user.blank? || ( @@cache_user.id != id )
    @@cache_user
  end
end
