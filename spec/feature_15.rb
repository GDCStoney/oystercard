require_relative '../lib/journey'
require_relative '../lib/journeylog'
require_relative '../lib/oystercard'
require_relative '../lib/station'

card_test = Oystercard.new
entry_station = Station.new("Entry", 6)
exit_station = Station.new("Exit", 5)

puts "This should fail with no funds error"
begin
  card_test.touch_in(entry_station)
rescue => error
  puts error.message
end

card_test.top_up(10)

puts "\nTouch_in - this should not fail and start a journey"
card_test.touch_in(entry_station)
puts card_test.journey_log.journeys.inspect

puts "\nTouch_out - this should not fail and complete the journey"
card_test.touch_out(exit_station)
puts card_test.journey_log.journeys.inspect

puts "\nbalance should now be 9"
puts card_test.balance

puts "this should result in a penalty payment on the card"
begin
  card_test.touch_in(entry_station)
  card_test.touch_in(entry_station)
  puts card_test.balance

  card_test.touch_in(entry_station)
rescue StandardError => e
  puts e.message
  puts card_test.balance
end
