require 'logger'
require 'time'
require 'date'

filename = DateTime.now.strftime('%Y%m%d%H%M%S')
logger = Logger.new("./#{filename}.log")
logger.datetime_format = ''

log = []
a = []

File.open('ping.log'){|f|
  f.each_line{|line|
    error = line.chomp.split(",")
    log.push error
    if error[2] == "-"
      a.push f.lineno
    end
  }
}

a.each do |i|
  dt = Time.parse(log[i][0]) + log[i][2].to_i;
  accident = "#{log[i - 1][1]}, #{log[i - 1][0]} - #{dt.strftime("%Y%m%d%H%M%S")}"
  logger.error(accident)
end
