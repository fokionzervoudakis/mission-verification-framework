module Subject
  def initialize
    @observers = []
  end

  protected

  def attach(obj)
    @observers.push(obj)
  end

  def detach(obj)
    @observers.delete(obj)
  end

  def notify
    @observers.each { |observer| observer.update(self) }
  end
end
