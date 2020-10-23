class Oystercard
  attr_reader :balance, :journey_log

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 0
    @journey_log = JourneyLog.new(Journey)
  end

  def top_up(amount)
    fail "Can't exceed limit of £#{MAX_BALANCE}" if (@balance + amount) > MAX_BALANCE
    @balance += amount
  end

  def touch_in(station)
    touch_out(nil) if !@journey_log.journeys.empty? && @journey_log.current_journey?
    fail "Not enough credit [#{@balance}], TOP UP!" if @balance < MIN_BALANCE
    @journey_log.start(station)
  end

  def touch_out(station)
    @journey_log.finish(station)
    deduct(@journey_log.journeys.last.fare)
  end

  private
  def deduct(amount)
    @balance -= amount
  end
end
