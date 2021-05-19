require 'colorize'

class FileReader
  attr_reader :file_path, :file_lines, :error_message

  def initialize(file_path)
    @file_path = file_path
    @error_message = ' '
    begin
      @file_lines = File.readlines(@file_path)
      @lines_count = @file_lines.size
    rescue StandardError
      @file_lines = []
      @error_message = "Incorrect file path, correct your file path and try again\n".colorize(:red)
    end
  end
end
