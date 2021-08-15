require 'parking_lot'

class Carpark
  attr_reader :parking_lots

  def initialize
    @parking_lots = {}
    @vehicle_plates = {}
  end

  # Adds a parking lot for a specific vehicle type
  # @param [String] vehicle_type The type of vehicle you want to add parking lots for
  # @param [Integer] size number of lots for this specific vehicle type
  # @param [Integer] hourly_cost of parking for these lots
  def add_parking_lot(vehicle_type, size, hourly_cost)
    @parking_lots[vehicle_type] ||= ParkingLot.new(size, hourly_cost)
  end

  # Park a vehicle to the parking lot for the vehicle type
  # @param [String] vehicle_type The type of vehicle you want to park for
  # @param [String] plate_number of the vehicle to be parked
  # @param [Integer] entry_time of the vehicle to the carpark_system
  def park_vehicle(vehicle_type, plate_number, entry_time)
    raise 'Invalid vehicle type' unless @parking_lots[vehicle_type]

    if slot_number = @parking_lots[vehicle_type].park_vehicle(plate_number, entry_time)
      @vehicle_plates[plate_number] = [vehicle_type, slot_number]
      puts "Accept #{lot_name(vehicle_type, slot_number)}"
    else
      puts "Reject"
    end
  end

  # Exit a vehicle from the parking lot for the vehicle type
  # @param [String] plate_number of the vehicle to be exited
  # @param [Integer] exit_time of the vehicle from the carpark_system
  def exit_vehicle(plate_number, exit_time)
    if (vehicle_type, slot_number = @vehicle_plates[plate_number])
      cost = @parking_lots[vehicle_type].exit_vehicle(plate_number, exit_time)
      @vehicle_plates.delete(plate_number)
      puts "#{lot_name(vehicle_type, slot_number)} #{cost}"
    end
  end

  private

  # Generate lot name for the parking lot
  # @param [String] vehicle_type Type of vehicle
  # @param [slot_number] slot_number index of parking lot
  def lot_name(vehicle_type, slot_number)
    "#{vehicle_type.capitalize}Lot#{slot_number + 1}"
  end
end