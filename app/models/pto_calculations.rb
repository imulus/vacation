class PTOCalculations

  attr_accessor :imulite, :hours_used, :days_used

  def initialize(imulite)
    self.imulite = imulite
    calculate_pto_usage
  end

  def imulite=(imulite)
    write_attribute(:imulite, imulite)
    calculate_pto_usage
  end

  protected

  def calculate_pto_usage
    self.hours_used = self.imulite.pto_time_entries.
          where("datetime >= ? AND datetime <= ?", Date.today.beginning_of_year, Date.today.end_of_year).
          sum(:hours)
    self.days_used = self.hours_used / 7.5
  end

end