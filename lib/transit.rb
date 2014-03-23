require 'Date'

class Transit
  attr_reader :name, :id

  def self.all
    table_name = self.to_s.downcase
    results = DB.exec("SELECT * FROM #{table_name};")
    all = []
    results.each do |result|
      new_object = self.new(result)
      all << new_object
    end
    all
  end

  def save
    table_name = self.class.to_s.downcase
    results = DB.exec("INSERT INTO #{table_name} (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id'].to_i
  end

  def self.create_stop(line_id, station_id)
    results = DB.exec("INSERT INTO stops (station_id, line_id) VALUES ('#{station_id}', '#{line_id}') RETURNING id;")
    stop_id = results.first['id'].to_i
  end

  def delete
    table_name = self.class.to_s.downcase
    DB.exec("DELETE FROM #{table_name} WHERE id = #{self.id};")
    DB.exec("DELETE FROM stops WHERE #{table_name}_id = #{self.id};")
  end

  def self.remove_stop(line_id, station_id)
    results = DB.exec("DELETE FROM stops WHERE line_id = #{line_id} and station_id = #{station_id} RETURNING id;")
    stop_id = results.first['id'].to_i
  end


  def self.search(name)
    table_name = self.to_s.downcase
    results = DB.exec("SELECT * FROM #{table_name} WHERE name LIKE '%#{name}'")
    stations = []
    results.each do |result|
      stations << self.new(result)
    end
    stations.first
  end

  def self.exists?(name)
    results = self.search(name)
    !results.nil?
  end

  def update_name(new_name)
    @name = new_name
    table_name = self.class.to_s.downcase
    DB.exec("UPDATE #{table_name} SET name = '#{new_name}' WHERE id = #{self.id};")
  end

  def ==(other_station)
    self.name == other_station.name
  end

  def self.global_stops
    results = DB.exec("SELECT b.name line_name, c.name station_name, a.id stop_id FROM stops a INNER JOIN line b ON a.line_id = b.id INNER JOIN station c ON a.station_id = c.id;")
  end
end

class Line < Transit
 attr_reader :name, :id

  def all_stations
    field_name = self.class.to_s.downcase
    stations = []
    results = DB.exec("SELECT b.name, b.id FROM stops a INNER JOIN station b ON a.station_id = b.id WHERE a.#{field_name}_id = #{self.id};")
    results.each do |result|
      stations << Station.new(result)
    end
    stations
  end

   def arrivals(time = Time.now.strftime("%I:%M:%S"), run_id)
    results = DB.exec("SELECT b.name line_name, c.run_id run_number, c.arrival_time, d.name station_name FROM stops a INNER JOIN line b ON a.line_id = b.id INNER JOIN arrivals c ON a.id = c.stop_id INNER JOIN station d ON a.station_id = d.id WHERE d.name = '#{self.name}' AND arrival_time > time AND c.run_id = #{run_id};")
  end

end

class Station < Transit
  attr_reader :name, :id

   def all_lines
    field_name = self.class.to_s.downcase
    lines = []
    results = DB.exec("SELECT b.name, b.id FROM stops a INNER JOIN line b ON a.line_id = b.id WHERE a.#{field_name}_id = #{self.id};")
    results.each do |result|
      lines << Line.new(result)
    end
    lines
  end

  def arrivals(time = Time.now.strftime("%I:%M:%S"))
    results = DB.exec("SELECT b.name line_name, c.run_id run_number, c.arrival_time, d.name station_name FROM stops a INNER JOIN line b ON a.line_id = b.id INNER JOIN arrivals c ON a.id = c.stop_id INNER JOIN station d ON a.station_id = d.id WHERE d.name = '#{self.name}' AND arrival_time > time;")
  end
end

