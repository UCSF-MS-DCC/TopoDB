class HomeController < ApplicationController
    include HomeHelper
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
            log_new_cage(@newCage, current_user)
            gflash :success => "New cage #{@newCage.cage_number} successfully created"
            redirect_to home_strain_path(:strain => createCageParams[:strain]) 
        else
            gflash :error =>  "Something went wrong #{@newCage.errors.full_messages}"
            redirect_to root_path
        end
    end

    def cage 
        @cage = Cage.find_by(cage_number:singleCageParams[:cage_number])
        if @cage == nil
            redirect_to :controller => "error", :action => "error_404"
        elsif @cage.in_use == false
            redirect_to root_path
        else
            @mice = @cage.mice.where(removed:nil)
            @can_update_remove = @mice.count == 0 ? false : true
            @can_add_pups = @cage.cage_type != 'breeding' ? true : false
    
            @target_cages = Cage.where(strain:@cage.strain)
        end

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
        @c = Cage.find(params[:id])
        log_params = {}
        updateCageParams.each do |k, v|
            if v == "true" || v == "false"
                v = updateCageParams[:in_use] = ActiveModel::Type::Boolean.new.cast(v)
            end
            if v != @c[k.to_sym] 
                log_params[k.to_sym] = {:priorval => @c[k.to_sym], :newval => v }
            end
        end
        if @c && @c.update_attributes(updateCageParams) 
            log_update_cage(@c.cage_number, log_params, current_user)
            if updateCageParams[:in_use] == false
                gflash :success => "Cage #{@c.cage_number} was deleted."
                redirect_to root_path
            else
                gflash :success => "Cage #{@c.cage_number} was successfully updated."
                redirect_to home_cage_path(:cage_number => @c.cage_number)
            end
        else
            gflash :error => "Cage #{@c.cage_number} failed to update.#{@c.errors.full_messages}"
            redirect_to home_cage_path(:cage_number => @c.cage_number)
        end
    end

    def update_mouse
        mouse = params.keys.select{ |k| k.include?("mouse-") }.first
        mouse_id = mouse.split("-").second
        key = params[mouse].keys.first
        val = params[mouse][key.to_sym]
        @mouse = Mouse.find(mouse_id)
        old_value = @mouse[key.to_sym] == nil ? -1 : @mouse[key.to_sym]
        log_params = { :updateattr => key.to_s, :values => { :priorval => old_value, :newval => val } }

        respond_to do |format|
            if @mouse.update_attributes(key.to_sym => val)         
                if key == "designation"
                    tdc = val.scan(/\d+/)
                    @mouse.update_attributes(three_digit_code:tdc.first)
                end
                log_update_mouse(@mouse, log_params, current_user)
                format.html
                format.json { render :json => { :message => "Mouse updated" }, :status => :ok }
            else
                format.html
                format.json { render :json => { :error_message => @mouse.errors.full_messages }, :status => :unprocessable_entity }
            end
        end
    end

    def remove_mouse
        mouse = params.keys.select{ |k| k.include?("mouse-") }.first
        mouse_id = mouse.split("-").second
        key = params[mouse].keys.first
        val = params[mouse][key.to_sym]
        @mouse = Mouse.find(mouse_id)
        cage_number = @mouse.cage.cage_number
        old_value = @mouse[key.to_sym] == nil ? -1 : @mouse[key.to_sym]
        log_params = { :updateattr => key.to_s, :values => { :priorval => old_value, :newval => val } }

        respond_to do |format|
            if validate_date(val)
                @mouse.update_attributes(key.to_sym => val)  
                log_remove_mouse(cage_number, @mouse.id, current_user)
                format.html
                format.json { render :json => { :message => "Mouse removed" }, :status => :ok }
            else
                format.html
                format.json { render :json => { :error_message => "Invalid date" }, :status => :unprocessable_entity }
            end
        end
    end

    def update_tail_cut_date
        mouse = params.keys.select{ |k| k.include?("mouse-") }.first
        mouse_id = mouse.split("-").second
        key = params[mouse].keys.first
        val = params[mouse][key.to_sym]
        @mouse = Mouse.find(mouse_id)
        old_value = @mouse[key.to_sym] == nil ? -1 : @mouse[key.to_sym]
        log_params = { :updateattr => key.to_s, :values => { :priorval => old_value, :newval => val } }

        respond_to do |format|
            if validate_date(val)
                @mouse.update_attributes(key.to_sym => val)
                log_update_mouse(@mouse, log_params, current_user)
                format.html
                format.json { render :json => { :message => "Mouse updated" }, :status => :ok }
            else
                format.html
                format.json { render :json => { :error_message => "Invalid date" }, :status => :unprocessable_entity }
            end
        end
    end

    def update_mouse_cage
        mouse = params.keys.select{ |k| k.include?("mouse-") }.first
        mouse_id = mouse.split("-").second
        source_cage_id = params[mouse][:cage_id].split("->").first
        target_cage_id = params[mouse][:cage_id].split("->").second
        @mouse = Mouse.find(mouse_id)
        mouse_updates = {:cage_id => target_cage_id}
        # set weaning date for pups being transfered from their birth cage
        if @mouse.weaning_date == nil
            mouse_updates[:weaning_date] = Date.today
        end
        # if a mouse is being placed into a hybrid cage (> 1 gene), update its strain column values and its genotype column values
        if Cage.find(target_cage_id).strain.include?("/")
            strains = Cage.find(target_cage_id).strain.split("/")
            if strains[0] != @mouse.strain && strains[1] == @mouse.strain
                mouse_updates[:strain] = nil
                mouse_updates[:strain2] = @mouse.strain
                mouse_updates[:genotype] = nil
                mouse_updates[:genotype2] = @mouse.genotype
            end
        end
        #insert respond_to do block here. Be sure to send unprocessable entity response on a failed input
        respond_to do |format| 
            if @mouse && @mouse.update_attributes(mouse_updates)
                log_mouse_cage_transfer(@mouse, source_cage_id, target_cage_id, current_user)
                format.html
                format.json { render :json => { :message => "Mouse moved to new cage" }, :status => :ok }
            else
                format.html
                format.json { render :json => { :error_message => @mouse.errors.full_messages }, :status => :unprocessable_entity }
            end
        end
    end

    def new_pups # will need to refactor to fail the whole process if any pup is not added.
        cage_id = params[:cage].to_i
        @cage = Cage.find(cage_id)
        strain = @cage.strain.include?("/") ? @cage.strain.split("/").first : @cage.strain
        strain2 = @cage.strain.include?("/") ? @cage.strain.split("/").second : nil
        successful_saves_m = 0
        successful_saves_f = 0
        error_messages = []
        params[:female_pups].to_i.times.each do |p|
           @m = Mouse.new(sex:1, dob:params[:birthdate], parent_cage_id:cage_id, cage_id: cage_id, strain:strain, strain2:strain2)
            if @m.save
                successful_saves_f += 1
            else
                error_messages.push(@m.errors.full_messages)
            end
        end
        if successful_saves_f > 0
            log_new_pups(@cage.cage_number, "#{successful_saves_f} female", current_user)
        end
        params[:male_pups].to_i.times.each do |p|
            @m =  Mouse.new(sex:2, dob:params[:birthdate], parent_cage_id:cage_id, cage_id: cage_id, strain:strain, strain2:strain2)
            if @m.save
                successful_saves_m += 1
            else
                error_messages.push(@m.errors.full_messages)
            end
        end
        if successful_saves_m > 0
            log_new_pups(@cage.cage_number, "#{successful_saves_m} male", current_user)
        end
        if error_messages.count > 0
            gflash :error => "There was a problem adding new pups to Cage ##{Cage.find(cage_id).cage_number}. Contact an administrator for assistance."
        else
            gflash :success => "Pups were successfully added to Cage ##{Cage.find(cage_id).cage_number}."
        end
        redirect_to home_cage_path(:cage_number => Cage.find(cage_id).cage_number)
    end

    def assign_new_ids
        #first assign designations to all the pups, then log the list of designations and the cage to the Archive table
        @mice = Cage.find(params[:cage_id]).mice.where(weaning_date:nil).where(three_digit_code:nil)
        @mice_ids = []
        error_messages = []
        @mice.each do |m|
            @mouse = Mouse.find(m.id)
            @mouse.assign_full_designation
            if @mouse.save
                # push new designation to mice_ids list
                @mice_ids.push(@mouse.designation)
            else
                # if there is an error, save in an array for surfacing in a gritter message
                error_messages.push(@mouse.errors.full_messages)
            end
        end
        if error_messages.count == 0
            log_new_ids(Cage.find(params[:cage_id]).cage_number, @mice_ids, current_user)
            gflash :success => "Assigned IDs #{@mice_ids} to pups in Cage ##{Cage.find(params[:cage_id]).cage_number}"
            redirect_to home_cage_path(:cage_number => Cage.find(params[:cage_id]).cage_number)
        else
            gflash :error => "There was a problem assigning IDs to pups in Cage ##{Cage.find(params[:cage_id]).cage_number}, Contact an administrator for assistance. #{error_messages}"
        end
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
        params.require(:cage).permit(:cage_number, :strain, :cage_type, :location, :pups_m, :pups_f, :in_use)
    end

    def removeCageParams
    end

    def updateMouseParams
        params.permit(:genotype)
    end

    def newPupsParams 
        params.permit(:female_pups, :male_pups, :birthdate)
    end

end
