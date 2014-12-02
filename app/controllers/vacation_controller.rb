class VacationController < ApplicationController

  http_basic_authenticate_with name: ENV['VACATION_USER'],
   password: ENV['VACATION_USER'] if Rails.env != "development"

  def index
    @imulites = Imulite.pto_eligible.order(:first_name, :last_name)
  end
  
end
