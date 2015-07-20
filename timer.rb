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
    @paused = false
    Thread.new {
      while time_remains? && @running
        # Countdown
        system('cls')
        puts time_to_s
        sleep 1
      end
      time_up unless @paused
    }
  end

  def time_remains?
    Time.now < @end_time
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
    #system('cls')
    puts "It's Over!"
    Sound.play('alarm.wav')
    @running = false
  end

  def pause
    @running = false
    @paused = true
    @seconds = (@end_time - Time.now)
  end
  
  def running?
    @running || @paused
  end

  def paused?
    @paused
  end
end

require './getkey'

timer = Timer.new(2)
timer.start
while timer.running?
  key = GetKey.getkey
  timer.time_up if key == 's'.ord
  timer.pause if key == 'p'.ord
  timer.start if key == 'r'.ord && timer.paused?
end
