class ArchiveController < ApplicationController

    def index
        respond_to do |format|
            format.html
            format.json { render json: ArchiveDatatable.new(params) }
        end
    end


end