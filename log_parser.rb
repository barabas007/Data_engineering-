filename = 'access_log_2021.log'

access_log_lines = File.open(filename, 'r') do |f|
  f.readlines
end
signup_log_lines = access_log_lines.select do |line|
  line.include?('/signup?email=')
end

user_data = signup_log_lines.map do |line|
  parsed_line = line.split('" "').last
end

puts user_data 