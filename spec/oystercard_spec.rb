require 'oystercard'
require 'station'
require 'journey'
require 'journeylog'

describe Oystercard do

  let (:entry_station) { Station.new("Entry", 1)}
  let (:exit_station) { Station.new("Exit", 6)}

  it { is_expected.to respond_to(:balance) }
  it { is_expected.to respond_to(:top_up) }
  it { is_expected.to respond_to(:touch_in).with(1).argument }
  it { is_expected.to respond_to(:touch_out).with(1).argument }


  describe '.balance' do
    it 'returns the balance of the card' do
      expect(subject.balance).to eq 0
    end
  end

  describe "#top_up()" do
    it "adds balance to the card" do
      expect(subject.top_up(5)).to eq 5
    end
    it "edge case for max top up allowed" do
      expect(subject.top_up(90)).to eq 90
    end

    it 'throws an error when trying to exceed £90' do
      expect { subject.top_up(91) }.to raise_error("Can't exceed limit of £90")
    end
  end

  describe '.touch_in' do
    it 'changes in_journey to be true' do
      subject.top_up(5)
      subject.touch_in(:entry_station)
      expect(subject.journey_log.current_journey?).to eq true
    end
    it "throws an error if balance has insufficent funds" do
      expect { subject.touch_in(:entry_station)}.to raise_error "Not enough credit [0], TOP UP!"
    end

    it 'remembers the entry station' do
      subject.top_up(5)
      subject.touch_in(:entry_station)
      expect(subject.journey_log.journeys.last.entry_station).to eq :entry_station
    end
  end

  describe '.journey' do
    it 'the card has an empty list of journeys by default' do
      expect(subject.journey_log.journeys).to eq []
    end
    it 'logs a journey' do
      subject.top_up(5)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journey_log.journeys.size).to eq 1
    end
  end
end

RSpec.describe Station do
  let(:station) { Station.new("station001", 0) }

  describe "#able to create a station" do

    it " - responds to a request for a stations name" do
      expect(station).to respond_to(:name)
    end

    it " - gives a name to the Station on initialisation" do
      expect(station.name).to eq "station001"
    end

    it " - responds to a request for a stations zone" do
      expect(station).to respond_to(:zone)
    end

    it " - gives a zone to the Station on initialisation" do
      expect(station.zone).to eq 0
    end
  end
end

RSpec.describe Journey do
  let(:entry_station) { Station.new("station001", 1) }
  let(:exit_station) { Station.new("station002", 4) }
  describe 'create new journey' do
    it 'enables a new journey to be created ' do
      expect {Journey.new(entry_station)}.to_not raise_error
    end
  end
  let(:journey) { Journey.new(entry_station) }
  let(:subject) { journey }

  describe '#fare' do
    it { is_expected.to respond_to(:fare) }

    it 'returns penalty fare for a invalid journey' do
      allow(subject).to receive(:valid_journey?).and_return false
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
  end
end

RSpec.describe JourneyLog do
  let(:entry_station) { Station.new("Entry", 1) }
  let(:exit_station) { Station.new("Exit", 6) }
  subject {JourneyLog.new(Journey)}

  it {is_expected.to respond_to(:start).with(1).argument }

  it {is_expected.to respond_to(:finish).with(1).argument }

  it {is_expected.to respond_to(:current_journey?) }

  it {is_expected.to respond_to(:journeys) }

  describe "- start creates a journey in journeys" do
    it "- creates a journey" do
      subject.start(entry_station)
      expect(subject.journeys.last.entry_station).to eq entry_station
    end
  end

  describe "- finish completes a journey" do
    it "- completes the last journey in journeys" do
      subject.start(entry_station)
      subject.finish(exit_station)
      expect(subject.journeys.last.exit_station).to eq exit_station
    end
  end

  describe "- finish completes a journey" do
    it "- completes the last journey in journeys" do
      subject.start(entry_station)
      subject.finish(exit_station)
      expect(subject.journeys.last.exit_station).to eq exit_station
    end
  end

end
