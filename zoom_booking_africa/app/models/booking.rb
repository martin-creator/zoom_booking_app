class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :meeting

  def show_purchased_at
    "#{self.created_at.to_datetime.strftime(" %a, %b, %d - %I:%M %p ")}(AEDT)"
  
  end

  after_create :send_confirmation_email

  private
  def send_confirmation_email
    PayMailer.confirm(self).deliver_now
  end
  
end



