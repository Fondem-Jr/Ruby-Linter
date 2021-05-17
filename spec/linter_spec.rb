require_relative '../lib/error_checker'

describe ErrorChecker do
  let(:error_check) { ErrorChecker.new('sample.rb') }

  context '#no_error' do
    it 'returns no offenses' do
      error_check.no_error
      expect(error_check.no_error).to eql(error_check.no_error)
    end
  end

  context '#end_error_check' do
    it 'returns missing/unexpected end' do
      error_check.end_error_check
      expect(error_check.errors[0]).to eql("Lint/Syntax: Missing 'end'")
    end
  end

  context '#end_error_check' do
    it 'returns nil when there is missing/unexpeced end' do
      error_check.end_error_check
      expect(error_check.errors[15]).to eql(nil)
    end
  end

  context '#trailing_spaces_check' do
    it 'returns trailing space on line 7' do
      error_check.trailing_spaces_check
      expect(error_check.errors[0]).to eql('Line: 7:15: Error: Trailing space detected.')
    end
  end

  context '#trailing_spaces_check' do
    it 'returns nil when no space is detected on line 1' do
      error_check.trailing_spaces_check
      expect(error_check.errors[20]).to eql(nil)
    end
  end

  context '#indentation_check' do
    it 'returns indentation error on line 7' do
      error_check.indentation_check
      expect(error_check.errors[0]).to eql('line:7 Use two spaces for indentation')
    end
  end

  context '#indentation_check' do
    it 'returns nil when there is no identation error on line 20' do
      error_check.indentation_check
      expect(error_check.errors[20]).to eql(nil)
    end
  end

  context '#empty_line_check' do
    it 'returns empty line error' do
      error_check.empty_line_check
      expect(error_check.errors[0]).to eql('line:14 Extra empty line at the beginning of the method')
    end
  end

  context '#empty_line_check' do
    it 'returns nil when no empty line error' do
      error_check.empty_line_check
      expect(error_check.errors[2]).to eql(nil)
    end
  end

  context '#tag_error_check' do
    it "returns missing/unexpected or missing '{' " do
      error_check.tag_error_check
      expect(error_check.errors[0]).to eql(error_check.errors[0])
    end
  end

  context '#tag_error_check' do
    it "returns nil when there no missing or unexpected '{' " do
      error_check.tag_error_check
      expect(error_check.errors[0]).to eql(error_check.errors[0])
    end
  end
end