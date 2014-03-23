require 'spec_helper'

describe Station do
  it  'initializes a new station object with a name' do
    new_station = Station.new({'name' => 'Panda'})
    new_station.should be_an_instance_of Station
  end

  it 'can save itself' do
    new_station = Station.new({'name' => 'Panda'})
    new_station.save
    Station.all
  end

  it 'has an empty all array to begin' do
    Station.all.should eq []
  end

   it 'can create a stop at itself' do
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_line.save
    new_station = Station.new({'name' => 'Panda'})
    new_station.save
    test_result = Station.create_stop(new_line.id, new_station.id)
    test_result.should be_an_instance_of Fixnum
  end

  it 'can delete itself' do
    new_station = Station.new({'name' => 'Trans-Siberian'})
    new_station.save
    new_station.delete
    Station.all.should eq []
    test_result = DB.exec("SELECT count(id) num_records FROM stops WHERE station_id = #{new_station.id};")
    test_result.first['num_records'].to_i.should eq 0
  end

  it 'can remove a line running through it' do
    new_station = Station.new({'name' => 'Trans-Siberian'})
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_station.save
    new_line.save
    Station.create_stop(new_line.id, new_station.id)
    Station.remove_stop(new_line.id, new_station.id)
    test_result = DB.exec("SELECT count(id) num_records FROM stops WHERE station_id = #{new_station.id} and line_id = #{new_line.id};")
    test_result.first['num_records'].to_i.should eq 0
  end

  it 'returns a list of stations matching a name' do
    new_station = Station.new({'name' => 'Trans-Siberian'})
    new_station.save
    Station.search("Trans-Siberian").should eq new_station
  end

  it 'equals another station with the same name' do
    new_station1 = Station.new({'name' => 'Trans-Panda'})
    new_station2 = Station.new({'name' => 'Trans-Panda'})
    new_station1.should eq new_station2
  end

   it 'will return a list of all its stations' do
    new_station = Station.new({'name' => 'Panda'})
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_station.save
    new_line.save
    Station.create_stop(new_line.id, new_station.id)
    new_station.all_lines.should eq [new_line]
  end

  it 'can change its name' do
    new_station = Station.new({'name' => 'Panda'})
    new_station.update_name('Red Panda')
    new_station.name.should eq "Red Panda"
  end

  it 'knows whether a line with the same name already exists' do
    new_station1 = Station.new({'name' => 'Trans-Panda'})
    new_station1.save
    Station.exists?('Trans-Panda').should eq true
  end
end
