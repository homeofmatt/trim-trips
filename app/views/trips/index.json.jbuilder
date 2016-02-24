json.array!(@trips) do |trip|
  json.extract! trip, :id, :origin, :destination
  json.url trip_url(trip, format: :json)
end
