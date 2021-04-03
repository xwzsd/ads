module Geocoder
  def geocoder
    coordinates ||= geocoder_service.coordinates(city)
    { lat: coordinates[0], lon: coordinates[1] }
  end

  private

  def geocoder_service
    @geocoder_service ||= GeocoderService::Client.new
  end

  def city
    params['city']
  end
end
