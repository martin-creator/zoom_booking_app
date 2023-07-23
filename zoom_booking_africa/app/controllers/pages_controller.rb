class PagesController < ApplicationController

  before_action :authenticate_user!, only: [:dashboard]

  def home
    @meetings = Meeting.upcoming
  end

  def about
  end

  def contact
  end

  def dashboard
    @my_upcoming_meetings = Meeting.upcoming.joins(:bookings).where("bookings.user_id = ?", current_user.id)

    @my_bookings = current_user.bookings
  end

  def thank_you
  end
end
