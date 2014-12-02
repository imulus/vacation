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

    def self.pto_eligible
      where(active: true).where(pto_eligible: true)
    end
end
