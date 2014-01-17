require 'rest-client'
require 'nokogiri'

page = Nokogiri::HTML(RestClient.get('http://apps.cs.utexas.edu/unixlabstatus/'))
cs_host = page.css('tr td[style="background-color: white; text-align: left;"]')
cs_user = page.css('tr td[style="background-color: white; text-align: center;"]')
cs_load = page.css('tr td[style="background-color: white; text-align: right;"]')

formatted_hosts = []
formatted_users = []
formatted_stats = []
formatted_loads = []
formatted_freed = []

cs_host.each do |host|
  mod = host.to_s
  formatted_hosts << mod.gsub('<td class="ruptime" style="background-color: white; text-align: left;">', '').gsub('</td>', '')
end

cs_user.each do |user|
  mod = user.to_s
  mod.gsub!('<td class="ruptime" style="background-color: white; text-align: center;">', '').gsub!('</td>', '')
  if mod.to_i.to_s == mod.to_s
    formatted_users << mod
  else
    formatted_stats << mod
  end
end

cs_load.each do |load|
  mod = load.to_s
  unless mod.include?('+') or mod.include?(',')
    formatted_loads << mod.gsub('<td class="ruptime" style="background-color: white; text-align: right;">', '').gsub('</td>', '')
  end
end

((formatted_hosts.count == formatted_users.count) == (formatted_loads.count == formatted_stats.count)) ? num = formatted_hosts.count : num = 0

for i in 0..num
  if formatted_users[i] == '0' and formatted_loads[i] == '0.00' and formatted_stats[i] == 'up'
    formatted_freed << i.to_i
  end
end

if formatted_freed.count > 0
  chosen = formatted_freed.shuffle.first.to_i
  puts "#{formatted_hosts[chosen]}.cs.utexas.edu"
else
  puts 'Error'
end
