class Meeting < ApplicationRecord
    include Zoom
    has_many :bookings

    validates :topic, presence: true, length: { minimum: 50 }
    validates :image, presence: true
    validates :start_time, presence: true
    validates :duration, presence: true

    after_create :create_zoom_meeting
    after_create :update_zoom_meeting

    def create_zoom_meeting
        payload = {
            topic: self.topic,
            password: self.password,
            start_time: self.start_time.to_datetime.strftime("%Y-%m-%dT%H:%M:%S"),
            duration: self.duration,
            timezone: "Australia/Sydney",
        }

        # create a zoom meeting on zoom server
        puts "Creating zoom meeting >>>>>>>>>>>>>>>>>>>>>>"
        zoom_meeting = Zoom::MeetingService.new.create_meeting(payload)
        data = JSON.parse(zoom_meeting)

        # save zoom meeting id to database
        puts "Saving zoom meeting id >>>>>>>>>>>>>>>>>>>>>>"
        puts data 
        self.zoom_id = data["id"].to_i 
        self.save
    end

    def update_zoom_meeting
        puts "Updating zoom meeting >>>>>>>>>>>>>>>>>>>>>>"
        puts self.topic
    end

end
