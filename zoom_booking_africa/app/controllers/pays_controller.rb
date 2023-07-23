class PaysController < ApplicationController
    before_action :authenticate_user!
    before_action :set_meeting
  
    def purchase 
    end

    def join_free
        # check if user already joined
        if Booking.exists?(user_id: current_user.id, meeting_id: @meeting.id)
            flash[:alert] = "You already joined this meeting"
            
        else
            @booking = Booking.create(user_id: current_user.id, meeting_id: @meeting.id, price: @meeting.price)
            flash[:notice] = "You have successfully joined this meeting"
        end
        redirect_to dashboard_path
    end

    private
    
    def set_meeting
        @meeting = Meeting.find(params[:meeting_id])
    end

end