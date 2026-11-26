class MeetingEventsController < ApplicationController
  before_action :require_login
  before_action :set_meeting_event, only: %i[show destroy]

  def new
    @meeting_event = MeetingEvent.new
    2.times { @meeting_event.meeting_participants.build }
    @recent_meeting_events = current_user.meeting_events
                                         .includes(:meeting_participants)
                                         .order(created_at: :desc)
                                         .limit(10)
  end

  def create
    @meeting_event = current_user.meeting_events.build(meeting_event_params)
    assign_scheduled_at_from_parts

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

    @recent_meeting_events = current_user.meeting_events
                                         .includes(:meeting_participants)
                                         .order(created_at: :desc)
                                         .limit(10)
    while @meeting_event.meeting_participants.size < 2
      @meeting_event.meeting_participants.build
    end
    render :new, status: :unprocessable_content
  end

  def show
    @restaurants = PlaceSearchService.fetch_restaurants(
      lat: @meeting_event.midpoint_lat,
      lng: @meeting_event.midpoint_lng,
      station_name: @meeting_event.midpoint_station_name
    )
  end

  def destroy
    @meeting_event.destroy!
    redirect_to new_meeting_event_path, notice: "計算履歴を削除しました", status: :see_other
  end

  private

  def set_meeting_event
    @meeting_event = current_user.meeting_events.includes(:meeting_participants).find(params[:id])
  end

  def assign_scheduled_at_from_parts
    date_str = params.dig(:meeting_event, :scheduled_date).to_s
    hour_str = params.dig(:meeting_event, :scheduled_hour).to_s
    minute_str = params.dig(:meeting_event, :scheduled_minute).to_s

    return if date_str.blank? || hour_str.blank? || minute_str.blank?

    @meeting_event.scheduled_at = Time.zone.parse("#{date_str} #{hour_str.rjust(2, '0')}:#{minute_str.rjust(2, '0')}:00")
  rescue ArgumentError
    @meeting_event.errors.add(:scheduled_at,
      :note, "の形式が正しくありません")
  end

  def meeting_event_params
    params.require(:meeting_event).permit(
      :title,
      :scheduled_at,
      :note,
      meeting_participants_attributes: %i[id name station_name _destroy]
    )
  end
end
