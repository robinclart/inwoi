class Invoice < ActiveRecord::Base
  belongs_to :account

  validates :uid, presence: true, uniqueness: true

  def next_uid
    uid.next if uid.present?
  end
end
