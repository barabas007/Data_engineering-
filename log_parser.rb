require 'CSV'


def parse_log

filename = 'access_log_2021.log'

access_log_lines = File.open(filename, 'r') do |f|
  f.readlines
end
signup_log_lines = access_log_lines.select do |line|
  line.include?('/signup?email=')
end

user_data = signup_log_lines.map do |line|
  parsed_array = line.split('" "')
  email = extract_email(parsed_array.first) 
  user_agent_string = parsed_array.last
  browser = determine_browser(user_agent_string)
  [email, browser]
end

cross_referenced_data = user_data.map do |line|
  cross_reference(line) 
end

cross_referenced_data

#puts user_data
end  

def determine_browser(user_agent)
  return 'Firefox' if user_agent.include?('Firefox') && user_agent.include?('Gecko')
  return 'Chrome' if user_agent.include?('Chrome')
  return 'Safari' if user_agent.include?('Gecko') && user_agent.include?('Safari')
  'Other'
end

def extract_email(log_line)
  email = log_line.match(/signup\?email\=([a-zA-Z0-9@.]*) HTTP\//)
  email.captures.first 
end

def cross_reference(log_line)
  users = CSV.open('users.csv') do |csv|
    csv.readlines 
  end
  users.map! do |line|
    if line.length == 3
      if line[0].nil?
        line[0] = 'Unknown'
      end
      if line[1].nil?
        line[1] = 'Unknown'
      end
    else
      if line[0].match(/[a-zA-Z0-9@.]*/)
        email = line[0]
        line[0] = 'Unknown'
        line.push('Unknown')
        line.push(email)
      end
    end
    line 
  end 
  matching_users = users.select do |line|
    log_line[0] == line[2]

  end 
  matching_user = matching_users.first

  { first_name: matching_user[1],
    last_name: matching_user[0], 
    email: matching_user[2],
    browser: log_line[1] 
  }
   
end

#p cross_reference("")

 p parse_log 