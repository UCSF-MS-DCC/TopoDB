class HomeController < ApplicationController
    def index 
        respond_to do |format|
            format.html 
            format.json { render json: CageDatatable.new(params)}
        end
    end

    def cage 
        @mice = Mouse.where(cage_id:Cage.find_by(cage_number:singleCageParams[:cage_number]).id)
    end

    private

    def singleCageParams
        params.permit(:cage_number)
    end
end
