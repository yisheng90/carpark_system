require 'carpark_system'

describe Carpark do
  let(:carkpark) { Carpark.new() }

  describe '#add_parking_lot' do
    let(:vehicle_type) { 'car' }
    let(:size) { 2 }
    let(:hourly_cost) { 4 }
    subject { carkpark.add_parking_lot(vehicle_type, size, hourly_cost) }

    context 'when parking lots for the vehicle type does not exist in the carpark_system' do
      let(:vehicle_type) { 'motorcycle' }

      before { subject }

      it 'add parking lots for the vehicle type to the carpark_system' do
        parking_lot = carkpark.parking_lots[vehicle_type]

        expect(carkpark.parking_lots.size).to eq(1)
        expect(parking_lot).to_not be_nil
        expect(parking_lot.size).to eq(size)
      end
    end

    context 'when parking lots for the vehicle type already exist in the carpark_system' do
      let(:size) { 7 }

      before do
        carkpark.add_parking_lot(vehicle_type, 2, hourly_cost)
        subject
      end

      it 'should not add parking lots for the vehicle type to the carpark_system' do
        parking_lot = carkpark.parking_lots[vehicle_type]
        expect(parking_lot).to_not be_nil
        expect(parking_lot.size).to eq(2)
      end
    end
  end

  describe '#park_vehicle' do
    let(:vehicle_type) { 'car' }
    let(:plate_number) { 'ABC123' }
    let(:entry_time) { Time.now.to_i }

    subject { carkpark.park_vehicle(vehicle_type, plate_number, entry_time) }

    context 'when there is free lot for the vehicle type' do
      before do
        carkpark.add_parking_lot(vehicle_type, 7, 4)
      end

      it 'output the vehicle is parked successfully message with lot number' do
        expect { subject }.to output("Accept CarLot1\n").to_stdout
      end
    end

    context 'when there is no free lot for the vehicle type' do
      before do
        carkpark.add_parking_lot(vehicle_type, 1, 4)
        carkpark.park_vehicle(vehicle_type, 'DEF134', entry_time)
      end

      it 'output the vehicle parked request rejected message' do
        expect { subject }.to output("Reject\n").to_stdout
      end
    end

    context 'when vehicle type is not available in this carpark_system' do
      it 'raise an error' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#exit_vehicle' do
    let(:vehicle_type) { 'car' }
    let(:plate_number) { 'ABC123' }
    let(:entry_time) { Time.now.to_i }
    let(:exit_time) { (Time.now + 3600 * 1.5).to_i }

    subject { carkpark.exit_vehicle(plate_number, exit_time) }

    context 'when there is free lot for the vehicle type' do
      before do
        carkpark.add_parking_lot(vehicle_type, 7, 4)
        carkpark.park_vehicle(vehicle_type, plate_number, entry_time)
      end

      it 'output the vehicle exited successfully message with lot number and cost of parking' do
        expect { subject }.to output("CarLot1 8\n").to_stdout
      end
    end
  end
end