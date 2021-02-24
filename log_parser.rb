
def parse_log

filename = 'access_log_2021.log'

access_log_lines = File.open(filename, 'r') do |f|
  f.readlines
end
signup_log_lines = access_log_lines.select do |line|
  line.include?('/signup?email=')
end

user_data = signup_log_lines.map do |line|
  parsed_line = line.split('" "').last
  determine_browser(parsed_line)
end

puts user_data
end  

def determine_browser(user_agent)
  return 'Firefox' if user_agent.include?('Firefox') && user_agent.include?('Gecko')
  return 'Chrome' if user_agent.include?('Chrome')
  return 'Safari' if user_agent.include?('Gecko') && user_agent.include?('Safari')
  'Other'
end

parse_log