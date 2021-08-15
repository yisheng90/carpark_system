require 'parking_lot'

describe ParkingLot do
  let(:hourly_cost) { 2 }
  let(:lot_size) { 1 }
  let(:parking_lot) { ParkingLot.new(lot_size, hourly_cost) }

  describe '#available_lot_number' do
    subject { parking_lot.available_lot_number }

    context 'with an lot of size 0' do
      let(:lot_size) { 0 }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when the size is specified' do
      let(:lot_size) { 2 }

      context 'when no vehicles are parked' do
        it 'returns first available slot index' do
          expect(subject).to eq(0)
        end
      end

      context 'when an existing vehicle is parked' do
        before do
          parking_lot.park_vehicle('ABC123', Time.now.to_i)
        end

        context 'when all the nearest lot were filled' do
          it 'returns the next available slot' do
            expect(subject).to eq(1)
          end
        end

        context 'when there is a nearer lot available' do
          before do
            parking_lot.park_vehicle('DEF123', Time.now.to_i)
            parking_lot.exit_vehicle('ABC123', Time.now.to_i)
          end

          it 'returns the nearest available slot' do
            expect(subject).to eq(0)
          end
        end
      end

      context 'when there is no free lot available' do
        before do
          parking_lot.park_vehicle('ABC123', Time.now.to_i)
          parking_lot.park_vehicle('DEF123', Time.now.to_i)
        end

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
    end
  end

  describe '#park_vehicle' do
    let(:lot_size) { 2 }
    let(:plate_number) { 'ABC123' }
    let(:entry_time) { Time.now.to_i }
    subject { parking_lot.park_vehicle(plate_number, entry_time) }

    context 'with there is a available lot' do
      it 'return the lot index of the vehicle parked' do
        expect(subject).to eq(0)
        expect(parking_lot.lots[0]&.plate_number).to eq(plate_number)
      end
    end

    context 'with there is no available lot' do
      before do
        parking_lot.park_vehicle('DEF123', Time.now.to_i)
        parking_lot.park_vehicle('GHI123', Time.now.to_i)
      end

      it 'return nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#cost_of_parking' do
    let(:entry_time) { Time.now.to_i }
    let(:exit_time) { Time.now.to_i }
    subject { parking_lot.cost_of_parking(entry_time, exit_time) }

    context 'when parked duration is less than an hour' do
      it 'return hourly cost' do
        expect(subject).to eq(hourly_cost)
      end
    end

    context 'when parked duration is an hour' do
      it 'return hourly cost' do
        expect(subject).to eq(hourly_cost)
      end
    end

    context 'when parked duration between hours' do
      let(:exit_time) { (Time.now + 3600 + 500).to_i }

      it 'return hourly cost multiply by the next hour' do
        expect(subject).to eq(hourly_cost * 2)
      end
    end

    context 'when parked duration is exact hour' do
      let(:exit_time) { (Time.now + 3600 * 3).to_i }

      it 'return hourly cost multiply by the next hour' do
        expect(subject).to eq(hourly_cost * 3)
      end
    end
  end

  describe '#exit_vehicle' do
    let(:lot_size) { 2 }
    let(:plate_number_one) { 'ABC123' }
    let(:plate_number_two) { 'DEF123' }
    let(:plate_number) { plate_number_one }
    let(:entry_time) { Time.now.to_i }
    let(:exit_time) { (Time.now + 3600 * 1.5).to_i }

    before do
      parking_lot.park_vehicle(plate_number_one, entry_time)
      parking_lot.park_vehicle(plate_number_two, entry_time)
    end

    subject { parking_lot.exit_vehicle(plate_number, exit_time) }

    it 'return cost of parking and frees out the lot' do
      expect(subject).to eq(hourly_cost * 2)
      expect(parking_lot.lots[0]).to be_nil
    end
  end
end