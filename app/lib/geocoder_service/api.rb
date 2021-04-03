module GeocoderService
  module Api
    def coordinates(city)
      response = connection.post do |request|
        request.params['city'] = city
      end
      response.success? ? JSON.parse(response.body) : nil
    end
  end
end
