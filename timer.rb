class Timer
  require 'win32/sound'
  include Win32

  def initialize(minutes)
    @warning = true

    @minutes = minutes
    @seconds = @minutes * 60

    @start_time = Time.now
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
        if @warning && minutes_left <= 5.0
          Sound.play('warning.wav')
          @warning = false
        end
        sleep 0.2
      end
      time_up if running?
    }
  end

  def run_time
    @current_time - @start_time
  end

  def remaining_time
    @end_time - @current_time
  end

  def minutes_left
    (@end_time - @current_time) / 60
  end

  def time_remains?
    @current_time < @end_time
  end

  def time_to_s(seconds_float = remaining_time) #counts up instead of down
    seconds = (seconds_float % 60).to_i.to_s.rjust(2, '0')
    minutes = ((seconds_float / 60) % 60).to_i.to_s.rjust(2, '0')
    hours   = ((seconds_float / 3600) % 60).to_i.to_s.rjust(2, '0')
    "#{hours}:#{minutes}:#{seconds}"
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