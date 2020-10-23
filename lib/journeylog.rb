class JourneyLog
  attr_reader :journeys

  def initialize(journey_class)
    @journey_class = journey_class
    @journeys = []
  end

  def start(station)
    @journey = @journey_class.new(station)
    @journeys << @journey
  end

  def current_journey?
    !@journeys.last.exit_station
  end

  def finish(station)
    return @journey.exit_station = station if current_journey?
    @journeys << (@journey = @journey_class.new(nil))
  end
end
