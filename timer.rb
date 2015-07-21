class Timer
  require 'win32/sound'
  include Win32

  def initialize(minutes)
    @minutes = minutes
    @seconds = @minutes * 60

    @start_time = Time.new
    @current_time = Time.new
    @end_time = Time.new
  end

  def start
    @start_time = Time.now
    @end_time = @start_time + @seconds
    @running = true
    @paused = false
    Thread.new {
      while time_remains? && running?
        @current_time = Time.now if !@paused
        sleep 0.2
      end
      time_up if running?
    }
  end

  def time_remains?
    @current_time < @end_time
  end

  def time_to_s
    minutes = (((@end_time - @current_time) / 60) % 60).to_i.to_s.rjust(2, '0')
    seconds = ((@end_time - @current_time) % 60).to_i.to_s.rjust(2, '0')
    "#{minutes}:#{seconds}"
  end    

  def percent
    "#{((Time.now - @start_time)/(@end_time - @start_time)*100).to_i}%"
  end

  def time_up
    puts "It's Over!"
    Sound.play('alarm.wav')
    @running = false
  end

  def pause
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
