class Journey
  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_accessor :entry_station, :exit_station

  def initialize(entry)
    @entry_station = entry
  end

  def valid_journey?
    !!@entry_station && !!@exit_station
  end

  def fare
   valid_journey? ? MIN_FARE : PENALTY_FARE
  end
end
