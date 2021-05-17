#!/usr/bin/env ruby

require_relative '../lib/error_checker'
require_relative '../lib/errors'

checks = ErrorChecker.new(ARGV.first)

checks.end_error_check
checks.trailing_spaces_check
checks.indentation_check
checks.empty_line_check
checks.tag_error_check

if !checks.error_check.file_lines.empty? && checks.errors.empty?
  puts checks.no_error.to_s
else
  checks.errors.uniq.each do |err|
    puts "#{checks.error_check.file_path.colorize(:light_blue)} : #{err.colorize(:red)}"
  end
end

puts checks.error_check.error_message if checks.error_check.file_lines.empty?
