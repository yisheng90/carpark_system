class ParkingLot
  attr_reader :lots, :size

  Slot = Struct.new(:plate_number, :entry_time)

  def initialize(size, hourly_cost)
    @lots = []
    @size = size
    @hourly_cost = hourly_cost
  end

  # Park a vehicle to the parking lot
  # @param [String] plate_number of the vehicle to be parked
  # @param [Integer] entry_time of the vehicle to the carpark_system
  def park_vehicle(plate_number, entry_time)
    if slot_number = available_lot_number
      @lots[slot_number] = Slot.new(plate_number, entry_time)
    end

    slot_number
  end

  # Exit a vehicle from the parking lot
  # @param [String] plate_number of the vehicle to be exited
  # @param [Integer] exit_time of the vehicle from the carpark_system
  def exit_vehicle(plate_number, exit_time)
    target_slot_number = @lots.find_index do |lot|
      lot&.plate_number == plate_number
    end

    target_slot = @lots[target_slot_number]
    @lots[target_slot_number] = nil

    cost_of_parking(target_slot.entry_time, exit_time) if target_slot
  end

  # Get the available lot number
  def available_lot_number
    return 0 if @lots.empty? && @size > 0

    @lots.each_with_index do |lot, idx|
      return idx if lot.nil?
    end

    @lots.size < @size ? @lots.size : nil
  end

  # Calculate the cost of parking for
  # @param [Integer] entry_time of the vehicle parked
  # @param [Integer] exit_time of the vehicle parked
  def cost_of_parking(entry_time, exit_time)
    duration = exit_time - entry_time
    billable_hours = [(duration / 3600.0).ceil, 1].max

    billable_hours * @hourly_cost
  end
end