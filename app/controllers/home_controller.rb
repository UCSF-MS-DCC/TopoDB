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
        @mice = @cage.mice.where(removed:nil)
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
        mouse = params.keys.select{ |k| k.include?("mouse-") }.first
        mouse_id = mouse.split("-").second
        key = params[mouse].keys.first
        val = params[mouse][key.to_sym]
        @mouse = Mouse.find(mouse_id)
        if @mouse && @mouse.update_attributes(key.to_sym => val)
            if key == "designation"
                tdc = val.scan(/\d+/)
                @mouse.update_attributes(three_digit_code:tdc.first)
            end
            # indicate success
        else
            # raise errors
            puts @mouse.errors.full_messages
        end
    end

    def update_mouse_cage
        puts params
        mouse = params.keys.select{ |k| k.include?("mouse-") }.first
        mouse_id = mouse.split("-").second
        source_cage_id = params[mouse][:cage_id].split("->").first
        target_cage_id = params[mouse][:cage_id].split("->").second
        
        @mouse = Mouse.find(mouse_id)
        if @mouse && @mouse.update_attributes(cage_id:target_cage_id)
            redirect_to home_cage_path(:cage_number => Cage.find(source_cage_id).cage_number)
            puts "Mouse moved"
        else
            puts @mouse.errors.full_messages
            # raise errors in view
        end
    end

    def euthanize_mice
    end

    def transfer 
        @source = Cage.find(params[:cage])
    end

    def transfer_update
        @source = Cage.find(params[:cage])
        puts params[:cage]
    end

    def new_pups
        puts newPupsParams
        cage_id = params[:cage].to_i
        @cage = Cage.find(cage_id)
        strain = @cage.strain.include?("/") ? @cage.strain.split("/").first : @cage.strain
        strain2 = @cage.strain.include?("/") ? @cage.strain.split("/").second : nil
        puts "Strain: #{strain} Strain2: #{strain2}"
        params[:female_pups].to_i.times.each do |p|
           @m =  Mouse.new(sex:1, dob:params[:birthdate], parent_cage_id:cage_id, cage_id: cage_id, strain:strain, strain2:strain2)
            if !@m.save
                puts @m.errors.full_messages
            end
        end
        params[:male_pups].to_i.times.each do |p|
            @m =  Mouse.new(sex:2, dob:params[:birthdate], parent_cage_id:cage_id, cage_id: cage_id, strain:strain, strain2:strain2)
            if !@m.save
                puts @m.errors.full_messages
            end
        end
        redirect_to home_cage_path(:cage_number => Cage.find(cage_id).cage_number)
    end

    def assign_new_ids
        puts params[:cage_id]
        @mice = Cage.find(params[:cage_id]).mice.where(weaning_date:nil).where(three_digit_code:nil)
        @mice.each do |m|
            @mouse = Mouse.find(m.id)
            @mouse.assign_full_designation
            @mouse.save
        end

        redirect_to home_cage_path(:cage_number => Cage.find(params[:cage_id]).cage_number)
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
        params.permit(:genotype)
    end

    def newPupsParams 
        params.permit(:female_pups, :male_pups, :birthdate)
    end

end
