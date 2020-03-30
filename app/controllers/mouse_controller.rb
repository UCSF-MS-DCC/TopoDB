class MouseController < ApplicationController
    def index
    end

    def show
    end

    def new
        @mouse = Mouse.new
    end

    def create
        @mouse = Mouse.new(create_params)
        @mouse.cage_id = params[:cage_id]
        if @mouse.save
            gflash :success => "New mouse was saved."
            redirect_to cage_path(:id => params[:cage_id])
        else
            gflash :error => "Mouse was not saved. #{@mouse.errors.full_messages}"
            redirect_to cage_path(:id => params[:cage_id])
        end
    end

    def edit
    end

    def update
        @mouse = Mouse.find(params[:id])
        if @mouse.update_attributes(update_params)
            gflash :success => "Mouse was updated"
            respond_to do |format|
                format.json { render json: {"message": "Update successful"}, status: :accepted }
            end
        else
            gflash :error => "Mouse was not updated: #{@mouse.errors.full_messages}"
            respond_to do |format|
                format.json { render json: {"message": "Update failed"}, status: :unprocessable_entity }
            end
        end
    end

    def destroy
    end

    private
    def create_params
        params.require(:mouse).permit(Mouse.column_names.map{ |col| col.to_sym })
    end
    def update_params
        params.require(:new_col_value).permit(Mouse.column_names.map{ |col| col.to_sym }) #TODO: GET THE REMOVE MODAL CODE TO WORK WITH UPDATE METHOD
    end
    def add_to_experiment_params
        params.require(:new_col_value).permit(:experiment_id)
    end
end