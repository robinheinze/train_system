require 'spec_helper'

describe Arrival do

  describe '.initialize' do
    it 'initializes with arrival values' do
      test_arrival = Arrival.new(2, '16:45', 1)
      test_arrival.should be_an_instance_of Arrival
    end
  end

  describe 'save' do
    it 'saves arrival value to the all array' do
      test_arrival = Arrival.new(2, '08:12:00', 1)
      puts test_arrival.stop_id
      puts '*'*80
      test_arrival.save
      Arrival.all.should eq [test_arrival]
    end
  end

  describe 'Test.all' do
    it 'holds an empty array prior to creation of any arrival objects' do
      Arrival.all.should eq []
    end
    it 'holds an array of all created arrivals' do
      test_arrival = Arrival.new(2, '11:11', 2)
      test_arrival.save
      Arrival.all.should eq [test_arrival]
    end
  end

  describe '==' do
    it 'equals another arrival with an equivalent id' do
      test_arrival1 = Arrival.new(3, '02:45', 3, 1)
      test_arrival2 = Arrival.new(3, '02:45', 3, 1)
      test_arrival1.should eq test_arrival2
    end
  end
end

