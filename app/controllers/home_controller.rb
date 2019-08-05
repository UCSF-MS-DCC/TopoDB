class HomeController < ApplicationController
    def index 
        @new_cage = Cage.new
        @strain = nil
        respond_to do |format|
            format.html 
            format.json { render json: CageDatatable.new(params) }
        end
    end

    def create_cage
        puts createCageParams
        @newCage = Cage.new(createCageParams)
        if @newCage.save 
            redirect_to home_strain_path(:strain => createCageParams[:strain]) 
        else
            puts "Cage did not save #{@newCage.errors.full_messages}"
        end
    end

    def cage 
        @cage = Cage.find_by(cage_number:singleCageParams[:cage_number])
        puts @cage.mice.count
        @mice = @cage.mice.where.not(euthanized:true)
        @can_update_remove = @mice.count == 0 ? false : true
        @can_add_pups = @cage.cage_type != 'breeding' ? true : false

        @target_cages = Cage.where(strain:@cage.strain)
    end

    def strain
        puts singleStrainParams
        @strain = singleStrainParams[:strain]
        @new_cage = Cage.new
        respond_to do |format|
            format.html 
            format.json { render json: StrainDatatable.new(params, strain: @strain )}
        end
    end

    def update_cage
        # puts "UPDATE PARAMS: #{updateCageParams}"
        # puts params.to_json
        @c = Cage.find(params[:id])
        puts updateCageParams
        if @c && @c.update_attributes(updateCageParams)
            redirect_to home_cage_path(:cage_number => @c.cage_number)
        else
            #raise error here
        end
    end

    def update_mouse
    end

    def euthanize_mice
        Mouse.where(id:params[:euthanize_ids]).update_all(euthanized:true)
        redirect_to home_cage_path(cage_number:params[:cage])
    end

    def transfer 
        @cage1 = Cage.find(params[:cage])
    end

    def new_pups
        puts newPupsParams
        cage_id = params[:cage].to_i
        params[:female_pups].to_i.times.each do |p|
           @m =  Mouse.new(sex:"F", dob:params[:birthdate], parent_cage_id:cage_id, cage_id: cage_id, strain:Cage.find(cage_id).strain, euthanized:false)
            if !@m.save
                puts @m.errors.full_messages
            end
        end
        params[:male_pups].to_i.times.each do |p|
            @m = Mouse.new(sex:"M", dob:params[:birthdate], parent_cage_id:cage_id, cage_id: cage_id, strain:Cage.find(cage_id).strain, euthanized:false)
            if !@m.save
                puts @m.errors.full_messages
            end
        end
        redirect_to home_cage_path(:cage_number => Cage.find(cage_id).cage_number)
    end

    private

    def singleCageParams
        params.permit(:cage_number)
    end

    def singleStrainParams
        params.permit(:strain)
    end

    def createCageParams
        params.require(:cage).permit(:cage_number, :strain, :cage_type, :location)
    end

    def updateCageParams
        params.require(:cage).permit(:cage_number, :strain, :cage_type, :location, :pups_m, :pups_f)
    end

    def updateMouseParams
        params.require(:mouse).permit(:euthanized, :on_experiment)
    end

    def newPupsParams 
        params.permit(:female_pups, :male_pups, :birthdate)
    end

end
