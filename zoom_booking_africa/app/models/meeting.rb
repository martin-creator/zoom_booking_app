class Meeting < ApplicationRecord
  include Zoom
  has_many :bookings

  validates :topic, presence: true, length: { minimum: 10 }
  validates :image, presence: true
  validates :start_time, presence: true
  validates :duration, presence: true

  default_scope { order(start_time: :desc) }

  scope :upcoming, -> { where("start_time > ?", Date.today) }

  def is_premium
    self.price&. > 0
  end

  def show_start_time
    "#{self.start_time.to_datetime.strftime(" %a, %b, %d - %I:%M %p ")}(AEDT)"
  end

  def show_price
    if self.price == 0
      return "Free"
    else
      return "$#{self.price}"
    end
  end

  after_create :create_zoom_meeting
  after_update :update_zoom_meeting

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

    payload = {
      topic: self.topic,
      password: self.password,
      start_time: self.start_time.to_datetime.strftime("%Y-%m-%dT%H:%M:%S"),
      duration: self.duration,
    }

    # update a zoom meeting on zoom server
    puts "Updating zoom meeting >>>>>>>>>>>>>>>>>>>>>>"
    puts "Zoom id: #{self.zoom_id}"
    Zoom::MeetingService.new.update_meeting(self.zoom_id, payload)
  end
end
