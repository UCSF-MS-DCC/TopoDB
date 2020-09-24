class UtilController < ApplicationController
    def csv
        puts params
        @cage = Cage.find(params["id"])
        respond_to do |format|
            format.csv { send_data @cage.get_csv, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=Cage_#{@cage.cage_number}.csv" }
        end
    end
end