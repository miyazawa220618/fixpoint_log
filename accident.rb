require 'logger'
require 'time'
require 'date'

def ping_accident(log, time, number)
  filename = DateTime.now.strftime('%Y%m%d%H%M%S')
  logger = Logger.new("./#{filename}.log")
  logger.datetime_format = ''

  (number.length - time).times do |i|
    if (number[time + i - 1] - number[i]) == time - 1
      dt = Time.parse(log[number[time + i - 1]][0]) + log[number[time + i - 1]][2].to_i;
      accident = "#{log[number[i]][1]}, #{log[number[i]][0]} - #{dt.strftime("%Y%m%d%H%M%S")}"
      logger.error(accident)
    end
  end
end

log = []
number = []
last_line = 0

File.open('ping.log'){|f|
  f.each_line{|line|
    a = line.chomp.split(",")
    log.push a
    if a[2] == "-"
      number.push f.lineno
    end
  }
}

puts 'サーバ故障のタイムアウト回数を指定してください'
time = gets.to_i
ping_accident(log, time, number)
