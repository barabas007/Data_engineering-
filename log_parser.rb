filename = 'access_log_2021.log'

access_log = File.open(filename, 'r') do |f|
  f.readline
end
puts access_log.length 