class SharesController < ApplicationController
  def show
    @meeting_event = MeetingEvent.includes(:meeting_participants).find_by!(share_token: params[:token])
    @restaurants = PlaceSearchService.fetch_restaurants(
      lat: @meeting_event.midpoint_lat,
      lng: @meeting_event.midpoint_lng,
      station_name: @meeting_event.midpoint_station_name
    )
  end
end
