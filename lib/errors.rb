require 'strscan'
require 'colorize'
require_relative '../lib/error_checker'
require_relative 'read_file'

class ErrorTypes

  private
  
  def indentation_error(str, index, message, expected_value)
    strip_line = str.strip.split
    str_match = str.match(/^\s*\s*/)
    end_check = str_match[0].size.eql?(expected_value.zero? ? 0 : expected_value - 2)

    if str.strip.eql?('end') || strip_line.first == 'elsif' || strip_line.first == 'when'
      log_error("line:#{index + 1} #{message}") unless end_check
    elsif !str_match[0].size.eql?(expected_value)
      log_error("line:#{index + 1} #{message}")
    end
  end

  def empty_line_block_check(str, index)
    message = 'Extra empty line at the beginning of the block'
    return unless str.strip.split.include?('do')

    log_error("line:#{index + 2} #{message}") if @error_check.file_lines[index + 1].strip.empty?
  end

  def def_empty_line_check(str, index)
    message1 = 'Extra empty line at the beginning of the method'
    message2 = 'Extra empty line detected between method'

    return unless str.strip.split.first.eql?('def')

    log_error("line:#{index + 2} #{message1}") if @error_check.file_lines[index + 1].strip.empty?

    return unless @error_check.file_lines[index - 1].strip.split.first.eql?('end')

    log_error("line:#{index + 1} #{message2}")
  end
end
