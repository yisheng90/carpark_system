require 'carpark'

class Parser
  attr_reader :carpark

  def initialize(filename)
    @filename = filename
    @carpark = nil
  end

  def run!
    File.open(@filename).each do |line|
      initialize_carpark(line) && next if @carpark.nil?
      terms = line.split(' ')

      case terms[0]
      when 'Enter'
        vehicle_type, plate_number, entry_time = terms[1], terms[2], terms[3].to_i
        @carpark.park_vehicle(vehicle_type, plate_number, entry_time)
      when 'Exit'
        plate_number, exit_time = terms[1], terms[2].to_i
        @carpark.exit_vehicle(plate_number, exit_time)
      else
        raise ('Invalid action')
      end
    end
  end

  private

  def initialize_carpark(line)
    @carpark = Carpark.new
    car_count, motorcycle_count = line.split(' ').collect(&:to_i)
    @carpark.add_parking_lot('car', car_count, 2)
    @carpark.add_parking_lot('motorcycle', motorcycle_count, 1)
  end
end