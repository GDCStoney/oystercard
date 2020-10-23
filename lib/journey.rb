class Journey
  PENALTY_FARE = 6

  attr_accessor :entry_station, :exit_station

  def initialize(entry)
    @entry_station = entry
  end

  def valid_journey?
    !!@entry_station && !!@exit_station
  end

  def fare
   valid_journey? ? 1 + zones : PENALTY_FARE
  end

  private
  def zones
    (@exit_station.zone - @entry_station.zone).abs
  end
end
