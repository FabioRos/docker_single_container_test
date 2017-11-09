# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  tokens                 :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_password_set     :boolean          default(FALSE), not null
#  enabled                :boolean          default(TRUE), not null
#  first_name             :string
#  last_name              :string
#  role_id                :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Now disabled: :omniauthable, :registerable, :confirmable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User # This must be after devise config, never before.
  belongs_to :role, foreign_key: :role_id
  before_save :set_name_capitalize
  #before_save :set_flag_on_first_login - Email can be changed before first login

  # Sarbanes-Oxley Compliance: http://en.wikipedia.org/wiki/Sarbanes%E2%80%93Oxley_Act
  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W]).+/)
      errors.add :password, "must include at least one of each: lowercase letter, uppercase letter, numeric digit, special character."
    end
  end

  # Generate random password. E.g. massive-0091, chasm-8261, fog-553586...
  def self.generate_random_password
    word = [
        Bazaar.adj,
        Bazaar.item,
        Bazaar.super_adj,
        Bazaar.super_item
    ].sample.downcase.gsub(' ', '-')

    # Pad to 10 chars at least (word + dash + number)
    password_min_length = 10
    if word.length + 5 < password_min_length
      # Pad up to 10 chars
      padding = password_min_length - word.length
    else
      # Add 4 digits anyway
      padding = 5
    end

    "#{word}-#{rand.to_s[2..padding]}"
  end

  def set_random_password
    self.password = self.password_confirmation = User.generate_random_password
  end

  def set_flag_on_first_login
    # first_password_set is the flag used by front-end to inhibit the use of the app if the first password is not set.
    if encrypted_password_changed? and encrypted_password_was.present?
      self.first_password_set = true
    end
  end

  def set_name_capitalize
    self.first_name = self.first_name.capitalize if self.first_name
    self.last_name = self.last_name.capitalize if self.last_name
  end

  def notify_new_account(random_password)
    UserMailer.new_account(self, random_password).deliver_now
  end


end
