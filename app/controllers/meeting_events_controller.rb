class MeetingEventsController < ApplicationController
  def new
    @meeting_event = MeetingEvent.new
    2.times { @meeting_event.meeting_participants.build }
    @recent_meeting_events = if logged_in?
                               current_user.meeting_events
                                           .includes(:meeting_participants)
                                           .order(created_at: :desc)
                                           .limit(10)
                             else
                               []
                             end
  end

  def create
    @meeting_event = MeetingEvent.new(meeting_event_params)
    @meeting_event.user = current_user if logged_in?

    if @meeting_event.valid?
      points = @meeting_event.meeting_participants.map { |p| { name: p.name, station_name: p.station_name, lat: p.lat, lng: p.lng } }
      calc = MidpointCalculatorService.calculate(points)

      if calc
        @meeting_event.midpoint_station_name = calc[:station_name]
        @meeting_event.midpoint_line_name = calc[:line_name]
        @meeting_event.midpoint_lat = calc[:midpoint_lat]
        @meeting_event.midpoint_lng = calc[:midpoint_lng]
      end

      if @meeting_event.save
        redirect_to meeting_event_path(@meeting_event), notice: "中間駅とお店候補を算出しました！"
        return
      end
    end

    while @meeting_event.meeting_participants.size < 2
      @meeting_event.meeting_participants.build
    end
    render :new, status: :unprocessable_content
  end

  def show
    @meeting_event = MeetingEvent.includes(:meeting_participants).find(params[:id])
    @restaurants = PlaceSearchService.fetch_restaurants(
      lat: @meeting_event.midpoint_lat,
      lng: @meeting_event.midpoint_lng,
      station_name: @meeting_event.midpoint_station_name
    )
  end

  private

  def meeting_event_params
    params.require(:meeting_event).permit(
      :title,
      meeting_participants_attributes: %i[id name station_name _destroy]
    )
  end
end
