require 'parser'

describe Parser do
  let(:filename) { '' }
  let(:parser) { Parser.new(filename) }

  describe '#run!' do
    subject { parser.run! }

    context 'with the problem statement file' do
      let(:filename) { 'spec/fixtures/problem_statement.txt' }

      it 'returns the valid test output' do
        expect{ subject }.to output("Accept MotorcycleLot1\nAccept CarLot1\nMotorcycleLot1 2\nAccept CarLot2\nAccept CarLot3\nReject\nCarLot3 6\n").to_stdout
      end
    end

    context 'with the parser test input one file' do
      let(:filename) { 'spec/fixtures/parser_test_input_one.txt' }

      it 'returns the valid test output' do
        expect{ subject }.to output("Accept MotorcycleLot1\nAccept CarLot1\nReject\nAccept CarLot2\nReject\nCarLot1 10\nMotorcycleLot1 3\nAccept CarLot1\nAccept MotorcycleLot1\nReject\nCarLot1 6\n").to_stdout
      end
    end

    context 'with the parser test input two file' do
      let(:filename) { 'spec/fixtures/parser_test_input_two.txt' }

      it 'returns the valid test output' do
        expect{ subject }.to output("Reject\nAccept CarLot1\nReject\nAccept CarLot2\nAccept CarLot3\nCarLot2 8\nAccept CarLot2\nAccept CarLot4\n").to_stdout
      end
    end

    context 'with an invalid file' do
      let(:filename) { 'spec/fixtures/parser_test_input_invalid.txt' }

      it 'raise an error' do
        expect{ subject }.to raise_error(RuntimeError)
      end
    end
  end
end