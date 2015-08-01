class Session
	def initialize
    @initialized = Time.now
  end

  def end
    @ended = Time.now
  end
end