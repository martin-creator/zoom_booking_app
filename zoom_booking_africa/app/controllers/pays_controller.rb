class PaysController < ApplicationController
    before_action :authenticate_user!
    before_action :set_meeting
  
    def purchase 
         # check if user already joined
         if Booking.exists?(user_id: current_user.id, meeting_id: @meeting.id)
            flash[:alert] = "You already joined this meeting"
            return redirect_to dashboard_path
            
        else
        # create strpe checkout session

        checkout_session = Stripe::Checkout::Session.create({
            customer: current_user.stripe_customer_id,
            client_reference_id: @meeting.id,
            mode: 'payment',
            payment_method_types: ['card'],
            line_items: [{
                "price_data": {
                    "product_data": {
                        "name": @meeting.topic,
                        "description": @meeting.description,
                        "images": [@meeting.image],
                    },
                    "unit_amount": @meeting.price * 100,
                    "currency": "usd",
                },
                "quantity": 1,
            }],
            payment_intent_data: {
                "description": @meeting.description
            },
            success_url: thank_you_url,
            cancel_url: root_url,
        })

        return redirect_to checkout_session.url, allow_other_host: true
        end
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