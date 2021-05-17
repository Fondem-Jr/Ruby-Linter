# rubocop: disable Metrics/CyclomaticComplexity

require 'colorize'
require 'strscan'
require_relative 'errors'
require_relative 'read_file'

class ErrorChecker
  attr_reader :error_check, :errors

  def initialize(file_path)
    @errors = []
    @error_check = FileReader.new(file_path)
    @keywords = %w[begin module def class do if case unless]
  end

  def no_error
    'No offenses detected'.colorize(:green)
  end

  def log_error_message(error_msg)
    @errors << error_msg
  end

  def end_error_check
    number_of_keywords = 0
    number_of_ends = 0
    @error_check.file_lines.each_with_index do |str, _index|
      if @keywords.include?(str.split.first) ||
         str.split.include?('do')
        number_of_keywords += 1
      end
      number_of_ends += 1 if str.strip == 'end'
    end
    log_error_message("Lint/Syntax: Missing 'end'") if number_of_keywords > number_of_ends
    return unless number_of_keywords < number_of_ends
    log_error_message("Lint/Syntax: Unexpected 'end'")
  end

  def trailing_spaces_check
    @error_check.file_lines.each_with_index do |str, index|
      if !str.strip.empty? && str[-2] == ' '
        @errors << "Line: #{index + 1}:#{str.size - 1}: Error: Trailing space detected."
      end
    end
  end

  def indentation_check
    message = 'Use two spaces for indentation'
    current_value = 0
    indented_value = 0

    @error_check.file_lines.each_with_index do |str, index|
      strip_line = str.strip.split
      expected_value = current_value * 2
      reserved_words = %w[class def if elsif until module unless begin case]

      next unless !str.strip.empty? || !strip_line.first.eql?('#')

      if reserved_words.include?(strip_line.first) ||
         strip_line.include?('do')
        indented_value += 1
      end
      indented_value -= 1 if str.strip == 'end'

      next if str.strip.empty?

      indentation_error(str, index, expected_value, message)
      current_value = indented_value
    end
  end

  def empty_line_check
    @error_check.file_lines.each_with_index do |str, index|
      class_empty_line_check(str, index)
      def_empty_line_check(str, index)
      end_empty_line_check(str, index)
      empty_line_block_check(str, index)
    end
  end

  def indentation_error(str, index, expected_value, message)
    strip_line = str.strip.split
    str_match = str.match(/^\s*\s*/)
    end_check = str_match[0].size.eql?(expected_value.zero? ? 0 : expected_value - 2)

    if str.strip.eql?('end') || strip_line.first == 'elsif' || strip_line.first == 'when'
      log_error_message("line:#{index + 1} #{message}") unless end_check
    elsif !str_match[0].size.eql?(expected_value)
      log_error_message("line:#{index + 1} #{message}")
    end
  end

  def tag_errors(*args)
    @error_check.file_lines.each_with_index do |str, index|
      open_parenthesis = []
      close_parenthesis = []
      open_parenthesis << str.scan(args[0])
      close_parenthesis << str.scan(args[1])

      status = open_parenthesis.flatten.size <=> close_parenthesis.flatten.size

      if status.eql?(1)
        log_error_message("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[2]}' #{args[4]}")
      end
      if status.eql?(-1)
        log_error_message("line:#{index + 1} Lint/Syntax: Unexpected/Missing token '#{args[3]}' #{args[4]}")
      end
    end
  end

  def tag_error_check
    tag_errors(/\(/, /\)/, '(', ')', 'Parenthesis')
    tag_errors(/\{/, /\}/, '{', '}', 'Curly Bracket')
    tag_errors(/\[/, /\]/, '[', ']', 'Square Bracket')
  end

  def end_empty_line_check(str, index)
    return unless str.strip.split.first.eql?('end')

    return unless @error_check.file_lines[index - 1].strip.empty?

    log_error_message("line:#{index} Extra empty line at the end of the block body")
  end

  def empty_line_block_check(str, index)
    message = 'Extra empty line at the beginning of the block'
    return unless str.strip.split.include?('do')

    log_error_message("line:#{index + 2} #{message}") if @error_check.file_lines[index + 1].strip.empty?
  end

  def class_empty_line_check(str, index)
    msg = 'Extra empty line detected at class body beginning'
    return unless str.strip.split.first.eql?('class')

    log_error_message("line:#{index + 2} #{msg}") if @error_check.file_lines[index + 1].strip.empty?
  end

  def def_empty_line_check(str, index)
    message1 = 'Extra empty line at the beginning of the method'
    message2 = 'Extra empty line detected between method'

    return unless str.strip.split.first.eql?('def')

    log_error_message("line:#{index + 2} #{message1}") if @error_check.file_lines[index + 1].strip.empty?

    return unless @error_check.file_lines[index - 1].strip.split.first.eql?('end')

    log_error_message("line:#{index + 1} #{message2}")
  end
end
# rubocop: enable Metrics/CyclomaticComplexity
