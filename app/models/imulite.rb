class Imulite < ActiveRecord::Base
    has_many :time_entries

    def name
        "#{first_name} #{last_name}"
    end
end
