require 'spec_helper'

describe Line do
  it 'initializes a new line object with a name' do
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_line.should be_an_instance_of Line
  end

  it 'can save itself' do
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_line.save
    Line.all
  end

  it 'has an empty all array to begin' do
    Line.all.should eq []
  end

  it 'can create a stop on itself' do
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_line.save
    new_station = Station.new({'name' => 'Panda'})
    new_station.save
    test_result = Line.create_stop(new_line.id, new_station.id)
    test_result.should be_an_instance_of Fixnum
  end

  it 'can delete itself' do
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_line.save
    new_line.delete
    Line.all.should eq []
    test_result = DB.exec("SELECT count(id) num_records FROM stops WHERE line_id = #{new_line.id};")
    test_result.first['num_records'].to_i.should eq 0

  end

  it 'can remove a station on itself' do
    new_station = Station.new({'name' => 'Trans-Siberian'})
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_station.save
    new_line.save
    Line.create_stop(new_line.id, new_station.id)
    Line.remove_stop(new_line.id, new_station.id)
    test_result = DB.exec("SELECT count(id) num_records FROM stops WHERE station_id = #{new_station.id} and line_id = #{new_line.id};")
    test_result.first['num_records'].to_i.should eq 0
  end

  it 'returns a list of lines matching a name' do
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_line.save
    Line.search("Trans-Siberian").should eq new_line
  end

  it 'equals another line with the same name' do
    new_line1 = Line.new({'name' => 'Trans-Panda'})
    new_line2 = Line.new({'name' => 'Trans-Panda'})
    new_line1.should eq new_line2
  end

  it 'will return a list of all its stations' do
    new_station = Station.new({'name' => 'Panda'})
    new_line = Line.new({'name' => 'Trans-Siberian'})
    new_station.save
    new_line.save
    Line.create_stop(new_line.id, new_station.id)
    new_line.all_stations.should eq [new_station]
  end

  it 'can change its name' do
    new_line = Line.new({'name' => 'Panda'})
    new_line.update_name('Red Panda')
    new_line.name.should eq "Red Panda"
  end

  it 'knows whether a line with the same name already exists' do
    new_line1 = Line.new({'name' => 'Trans-Panda'})
    new_line1.save
    Line.exists?('Trans-Panda').should eq true
  end
end
