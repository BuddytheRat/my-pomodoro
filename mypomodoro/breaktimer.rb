class BreakTimer < Timer
  def initialize
    super(1)
    @warning = false
  end

  def time_remains?
    true
  end

  def time_to_s
    super(run_time)
  end
end