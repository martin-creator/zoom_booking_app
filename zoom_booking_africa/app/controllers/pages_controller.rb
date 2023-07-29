require 'jwt'
class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard, :receipt, :zoom, :thank_you, :generate_signature]

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

  def receipt
    @booking = current_user.bookings.where(id: params[:booking_id]).first
  
    if @booking
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "booking_#{@booking.id}", template: "pages/receipt", formats: [:html], disposition: "attachment"# Excluding ".pdf" extension.
        end
      end
    else
      redirect_to dashboard_path
    end
  end
  

  def thank_you
  end

  def zoom
    is_joined = current_user.bookings.exists?(meeting_id: params[:meeting_id])
    redirect_to dashboard_path, alert: "You are not authorized to view this page." if !is_joined

    @meeting = Meeting.find(params[:meeting_id])

  end

  def generate_signature
    mn = params[:meetingNumber]

    # Generate the Zoom SDK signature
    iat = Time.now.to_i - 30
    exp = iat + 60 * 60 * 2

    header = {
      alg: 'HS256',
      typ: 'JWT'
    }

    payload = {
      sdkKey: Figaro.env.client_id,
      mn: mn,
      role: 0,
      iat: iat,
      exp: exp,
      appKey: Figaro.env.client_id,
      tokenExp: exp
    }

    # Encode the header and payload
    signature = JWT.encode(payload, Figaro.env.client_secret , "HS256", header)
    render json: {signature: signature}, status: 200
  end

end
