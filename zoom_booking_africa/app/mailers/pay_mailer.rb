class PayMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pay_mailer.confirm.subject
  #
  def confirm(booking)
    @booking = booking

    mail(
      to: @booking.user.email,
      from: "MeetPlanner<admin@cwenshop.com>",
      subject: "Glad to have you in our '#{booking.meeting.topic}' meeting"
    )
  end
end
