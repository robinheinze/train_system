class Arrival
  attr_reader :stop_id, :arrival_time, :run_id, :id

  def initialize(stop_id, arrival_time, run_id, id = nil)
    @stop_id = stop_id
    @arrival_time = arrival_time
    @run_id = run_id
    @id = id
  end

  def save
    results = DB.exec("INSERT INTO arrivals (stop_id, arrival_time, run_id) VALUES (#{@stop_id}, '#{@arrival_time}', #{@run_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM arrivals;")
    arrivals = []
    results.each do |result|
      id = result['id'].to_i
      stop_id = result['stop_id'].to_i
      arrival_time = result['arrival_time']
      run_id = result['run_id'].to_i
      arrivals << Arrival.new(stop_id, arrival_time, run_id, id)
    end
    arrivals
  end

  def ==(other_arrival)
    self.id == other_arrival.id
  end
end
