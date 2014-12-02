class Project < ActiveRecord::Base
  has_many :time_entries

  def self.PTO
    find_by(name: 'PTO')
  end

end