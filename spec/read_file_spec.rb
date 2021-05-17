require_relative '../lib/read_file'

describe FileReader do
    let(:file) { FileReader.new('sample.rb') }

    context '#initialize' do
        it 'returns incorrect file path' do
            file.error_message
            expect(file.error_message).to eql(file.error_message)
        end
    end
end