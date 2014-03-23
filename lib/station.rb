require 'transit'
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
end
