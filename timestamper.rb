#!/usr/bin/env ruby
require 'time'

# This script reads the last line of the file to pull out the last timestamp in seconds,
# and sets that equal to the last modified time of the file.  It then processes the file
# line by line replacing the number of seconds with a human readable timestamp.

def read_last_line(f)
  pos = 2
  f.seek(-pos, File::SEEK_END)
  c = f.getc
  result = ''
  while c.chr != "\n"
    result.insert(0,c.chr)
    pos += 1
    f.seek(-pos, File::SEEK_END)
    c = f.getc
  end
  f.rewind
  return result
end

abort("Please pass a Java GC log as the first argument!") unless !ARGV[0].nil?

begin
  file = File.new(ARGV[0], mode="r")
rescue
  abort("Unable to open #{ARGV[0]} for reading!")
end

mtime = nil
last_time = nil
start_time = nil
if ARGV[1].nil? then
  mtime = file.mtime
  last_line = read_last_line(file)
  last_time = last_line.match(/^(\d+)/)[0].to_i
else
  start_time = Time.parse(ARGV[1])
end

matches = 0

file.each_line do |line|
  line.gsub!(/^(\d+)/) do |match|
    matches += 1
    if start_time.nil? then
      (mtime - (last_time - match.to_i)).strftime("%m/%d/%Y %H:%M:%S")
    else
      (start_time + match.to_i).strftime("%m/%d/%Y %H:%M:%S")
    end
  end
  puts line
end

if matches == 0 then
  $stderr.puts "Processed file, but found no matches.  Are you sure #{ARGV[0]} is a java GC log?"
end

