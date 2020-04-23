class ExperimentController < ApplicationController
    def index
        respond_to do |format|
            format.html
            format.json { render json: ExperimentDatatable.new(params) }
        end
    end

    def show
        @experiment = Experiment.find(show_params[:id])
        @experiment.update_last_viewed
        puts "VARIABLES COUNT: #{@experiment.variables.count}"
        puts "VARIABLES: #{@experiment.variables}"
        @experiment.variables.each do  |v|
            puts JSON.parse(v)
        end
        respond_to do |format|
            format.html 
            format.json 
        end
        @summary_stats = {}

    end

    def new
        @experiment = Experiment.new
    end

    def create
        vars = []
        create_update_params[:variables].each do |k,v|
            vars.push(v.to_json)
        end
        puts "VARS:#{vars}"
        new_experiment_params = create_update_params
        new_experiment_params[:variables] = vars
        @exp = Experiment.new(new_experiment_params)
        if @exp.save
            gflash :success => "Experiment #{@exp.name} saved"
            redirect_to experiment_index_path
        else
            gflash :error => "There was a problem saving experiment"
        end
    end

    def add_data

        # errors = []
        # params.select { |key, value| key.to_s.match(/^mouse/) }.each do |k, v|
        #     datapoint = Datapoint.new(mouse_id:k.split("-").last.to_i, timepoint:params[:timepoint], var_value:v, variable_name:)
        #     if !datapoint.save
        #         errors.push(datapoint.errors.full_messages)
        #     end
        # end
        # if errors.size == 0
        #     gflash :success => "New datapoints added"
        # else
        #     gflash :error => "There was a problem creating new datapoints. #{errors}"
        # end
        # redirect_to experiment_path(id:params[:experiment_id].to_i)
    end

    def update_data
        dp = params.select { |k, _| /^datapoint/.match(k) }
        Datapoint.find(dp.keys.first.split("-").last.to_i).update_attributes(var_value:dp[dp.keys.first]["var_value"])       
    end

    def add_new_datapoint
        datapoint = Datapoint.new(new_datapoint_params)
        respond_to do |format|
            if datapoint.save
                format.json { render json: {"message": "Datapoint saved"}, status: :created }
            else
                format.json { render json: {"message": "Datapoint not saved"}, status: :unprocessable_entity }
            end
        end
    end

    def edit
    end

    def update
        experiment = Experiment.find(params[:id])
        respond_to do |format| 
            if experiment && experiment.update_attributes(create_update_params)
                gflash :success => "Experiment was updated"
                format.html { redirect_to action: "show", id: params[:id] }
                format.json { render :json => { :message => "Experiment updated" }, :status => :ok }
            else
                gflash :error => "There was a problem updating the experiment. #{experiment.errors.full_messages}"
                format.html { redirect_to action: "show", id: params[:id] }
                format.json { render :json => { :error_message => experiment.errors.full_messages }, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
    end

    private

        def create_update_params
            params.require(:experiment).permit(:date, :name, :gene, :description, :id, :variables => {})
        end

        def show_params
            params.permit(:id)
        end

        def new_datapoint_params
            params.require(:datapoint).permit(:mouse_id, :timepoint, :var_value, :var_name)
        end


end