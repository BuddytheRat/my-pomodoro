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
      while Time.now < @end_time && @running
        sleep 1
        system('cls')
        puts time_to_s + ' | ' + percent
      end
      time_up
    }
  end

  def time_to_s
    minutes = (((@end_time - Time.now) / 60) % 60).to_i.to_s.rjust(2, '0')
    seconds = ((@end_time - Time.now) % 60).to_i.to_s.rjust(2, '0')
    "#{minutes}:#{seconds}"
  end    

  def percent
    "#{((Time.now - @start_time)/(@end_time - @start_time)*100).to_i}%"
  end

  def time_up
    system('cls')
    puts "It's Over!"
    Sound.play('alarm.wav')
    @running = false
  end
  
  def running?
    @running
  end
end

timer = Timer.new(0.2)
timer.start
while timer.running?
  
end
