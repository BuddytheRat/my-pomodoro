class Timer
  require 'win32/sound'
  include Win32

  def initialize(minutes)
    @minutes = minutes
    @seconds = @minutes * 60
    @running = false
    @start_time = Time.new
    @end_time = Time.new
  end

  def start
    @start_time = Time.now
    @end_time = @start_time + @seconds
    @running = true
    Thread.new {
      while Time.now < @end_time
        sleep 1
      end
      time_up
    }
  end

  def percent
    "#{((Time.now - @start_time)/(@end_time - @start_time)*100).to_i}%"
  end

  def time_up
    puts "It's Over!"
    Sound.play('alarm.wav')
    @running = false
  end
  
  def running?
    @running
  end
end

timer = Timer.new(0.1)
timer.start
while timer.running?
  system('cls')
  puts timer.percent
end
