class PTOCalculations

  attr_accessor :imulite, :hours_used, :days_used, :days_accrued, :days_left, :total_hours

  HOURS_PER_DAY = 7.5

  def initialize(imulite)
    self.imulite = imulite
    calculate_pto_usage
  end

  def imulite=(imulite)
    @imulite = imulite
    calculate_pto_usage
  end

  protected

  def calculate_pto_usage
    self.hours_used = self.imulite.pto_time_entries.
          where("datetime >= ? AND datetime <= ?", Date.today.beginning_of_year, Date.today.end_of_year).
          sum(:hours)
    self.days_used = (self.hours_used / HOURS_PER_DAY).round(2)
    self.days_accrued = (self.accrued_hours / HOURS_PER_DAY).round(2)
    self.days_left = ((self.hours_for_year - self.hours_used) / HOURS_PER_DAY).round(2)
  end

  def pto_vesting_date
    if self.imulite.start_date.present?
      @pto_vesting_date ||= self.imulite.start_date + 2.years
    else
      @pto_vesting_date ||= Time.now - 2.years - 1.day #assume no start date means vested imulite
    end
  end

  def accrued_hours
    calculate_year_hours if @accrued_hours.nil?
    @accrued_hours
  end

  def hours_for_year
    calculate_year_hours if @hours_for_year.nil?
    @hours_for_year
  end

  def calculate_year_hours
    start_date = self.imulite.start_date || Date.today.beginning_of_day - 2.years - 1.day
    calculation_date = [start_date, Date.today.beginning_of_year].max #get whatever is newer, the start of the year or their start date

    @accrued_hours = 0.0
    @hours_for_year = 0.0

    loop do
      calculation_date = calculation_date + 1.month
      accrue_increment = calculation_date <= pto_vesting_date ? (20.0 / 12.0) : (25.0 / 12.0)
      accrue_increment = accrue_increment * HOURS_PER_DAY
      #update the accrued hours and total hours for year based on the accrue increment
      @accrued_hours = @accrued_hours + accrue_increment if calculation_date < Date.today
      @hours_for_year = @hours_for_year + accrue_increment
      break if calculation_date > Date.today.end_of_year
    end 
    
  end

end