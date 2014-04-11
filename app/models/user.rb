class User < ActiveRecord::Base
  has_secure_password

  has_many :memberships
  has_many :accounts, through: :memberships

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def self.signup(attrs = {})
    account_name = attrs.delete(:account_name)
    user = new(attrs)
    user.signup(account_name)
  end

  def signup(account_name = nil)
    if save
      account_name ||= name
      accounts.create(name: account_name)
    end

    self
  end
end
