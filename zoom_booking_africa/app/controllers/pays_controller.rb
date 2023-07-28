# class PaysController < ApplicationController
#   before_action :authenticate_user!, except: [:webhook]
#   before_action :set_meeting, except: [:webhook]

#   def purchase
#     # check if user already joined
#     if Booking.exists?(user_id: current_user.id, meeting_id: @meeting.id)
#       flash[:alert] = "You already joined this meeting"
#       return redirect_to dashboard_path
#     end
#       # create strpe checkout session

#       checkout_session = Stripe::Checkout::Session.create({
#         customer: current_user.stripe_customer_id,
#         client_reference_id: @meeting.id,
#         mode: "payment",
#         payment_method_types: ["card"],
#         line_items: [{
#           "price_data": {
#             "product_data": {
#               "name": @meeting.topic,
#               "description": @meeting.description,
#               "images": [@meeting.image],
#             },
#             "unit_amount": @meeting.price * 100,
#             "currency": "usd",
#           },
#           "quantity": 1,
#         }],
#         payment_intent_data: {
#           "description": @meeting.description,
#         },
#         success_url: thank_you_url,
#         cancel_url: root_url,
#       })

#       return redirect_to checkout_session.url, allow_other_host: true
    
#   end

#   def join_free
#     # check if user already joined
#     if Booking.exists?(user_id: current_user.id, meeting_id: @meeting.id)
#       flash[:alert] = "You already joined this meeting"
#     else
#       @booking = Booking.create(user_id: current_user.id, meeting_id: @meeting.id, price: @meeting.price)
#       flash[:notice] = "You have successfully joined this meeting"
#     end
#     redirect_to dashboard_path
#   end

#   protect_from_forgery except: :webhook

#   def webhook
#     endpoint_secret = Rails.application.credentials.stripe[:webhook_secret_key]
#     event = nil

#     begin
#       sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
#       payload = request.body.read
#       event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
#     rescue JSON::ParserError => e
#       # Invalid payload
#       render json: { message: e }, status: 400
#       return
#     rescue Stripe::SignatureVerificationError => e
#       # Invalid signature
#       render json: { message: e }, status: 400
#       return
#     end

#     if event["type"] == "checkout.session.completed"
#       create_booking(event.data.object)
#     end

#     render json: { message: "success" }, status: 200
#   end

#   private

#   def set_meeting
#     @meeting = Meeting.find(params[:meeting_id])
#   end

#   def create_booking(checkout_session)
#     meeting = Meeting.find(checkout_session.client_reference_id)

#     # get user
#     user = User.find_by(stripe_customer_id: checkout_session.customer)

#     # create booking
#     Booking.create(user_id: user.id, meeting_id: meeting.id, price: meeting.price)

    
#   end
# end


class PaysController < ApplicationController
    before_action :authenticate_user!, except: [:webhook]
    before_action :set_meeting, except: [:webhook]
  
    def purchase
      # check if user already joined
      if Booking.exists?(user_id: current_user.id, meeting_id: @meeting.id)
        flash[:alert] = "You already joined this meeting"
        return redirect_to dashboard_path
      end
        # create strpe checkout session
  
        checkout_session = Stripe::Checkout::Session.create({
          customer: current_user.stripe_customer_id,
          client_reference_id: @meeting.id,
          mode: "payment",
          payment_method_types: ["card"],
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
            "description": @meeting.description,
          },
          success_url: thank_you_url,
          cancel_url: root_url,
        })

        puts checkout_session
  
        return redirect_to checkout_session.url, allow_other_host: true
      
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
  
    protect_from_forgery except: :webhook
    def webhook
      endpoint_secret = Rails.application.credentials.stripe[:webhook_secret_key]
      puts "Endpoint secret ----------------------------------------------------------------------------------"
      puts endpoint_secret
      puts "Endpoint secret ----------------------------------------------------------------------------------"
      event = nil
  
      begin
        sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
        payload = request.body.read
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue JSON::ParserError => e
        # Invalid payload
        render json: { message: e }, status: 400
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        render json: { message: e }, status: 400
        return
      end
  
      if event["type"] == "checkout.session.completed"
        puts "Creating booking"
        create_booking(event.data.object)
      end
  
      render json: { message: "success" }, status: 200
    end
  
    private
  
    def set_meeting
      @meeting = Meeting.find(params[:meeting_id])
    end
  
    def create_booking(checkout_session)
    puts "Creating booking"
      meeting = Meeting.find(checkout_session.client_reference_id)
  
      # get user
      user = User.find_by(stripe_customer_id: checkout_session.customer)
  
      # create booking
      Booking.create(user_id: user.id, meeting_id: meeting.id, price: meeting.price)
  
      
    end
  end
  
