require 'transit'
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

end
