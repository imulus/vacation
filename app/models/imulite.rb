class Imulite < ActiveRecord::Base
    has_many :time_entries

    def name
      "#{first_name} #{last_name}"
    end

    def pto_calculations
      @pto_calculations ||= PTOCalculations.new(self)
    end

    def pto_time_entries
      self.time_entries.where(project_id: Project.PTO.id)
    end

    def pto_start_date
      if self.start_date.present?
        if self.start_date.day < 15
          self.start_date.beginning_of_month
        else
          self.start_date.end_of_month + 1.day #go into next month as they don't really have any
        end
      else
        Time.now.beginning_of_month - 10.years #assume no start date means vested imulite
      end
    end

    def self.pto_eligible
      where(active: true).where(pto_eligible: true)
    end
end
