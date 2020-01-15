class HomeController < ApplicationController
    include HomeHelper

    before_action :authenticate_user!
    def index 
        @locations = Cage.where(in_use:true).pluck(:location).uniq
    end

    def main 
        puts "LOCATION: #{params[:location]}"
        @location = params[:location]
        @new_cage = Cage.new
        @loc_strains = Cage.where(in_use:true).where(strain2:["",nil]).where(location:@location).pluck(:strain).uniq
        @loc_hybrids = Cage.where(in_use:true).where.not(strain2:[nil,""]).where(location:@location).map { |cage| "#{cage.strain}/#{cage.strain2}" }.uniq
        @all_locations = Cage.pluck(:location).uniq
        @all_strains = Cage.pluck(:strain).uniq
        @locations = Cage.pluck(:location).uniq
    end

    def create_cage
        gts = [nil, "n/a", "+/+", "+/-", "-/-"]
        createParams = createCageParams
        if createCageParams[:strain2] == ""
            createParams[:strain2] = nil
        end
        createParams[:genotype] = gts.find_index(createCageParams[:genotype])
        createParams[:genotype2] = gts.find_index(createCageParams[:genotype2])
        location = createCageParams[:location]

        @newCage = Cage.new(createParams)
        strainpath = (createParams[:strain2] == nil || createParams[:strain2] == "") ? createParams[:strain] : "#{createParams[:strain]}_#{createParams[:strain2]}"
        if @newCage.save 
            log_new_cage(@newCage, current_user)
            gflash :success => "New cage #{@newCage.cage_number} successfully created"
            redirect_to home_strain_path(:strain => strainpath, :location => location) 
        else
            gflash :error =>  "New cage was not saved #{@newCage.errors.full_messages}"
            redirect_to home_strain_path(:strain => strainpath, :location => location)
        end
    end

    def cage 
        @cage = Cage.find_by(cage_number:singleCageParams[:cage_number])
        @strains = Cage.where(in_use:true).where(strain2:["",nil]).pluck(:strain).uniq
        @strain = (["",nil].include? @cage.strain2) ? @cage.strain : "#{@cage.strain}_#{@cage.strain2}"
        @locations = Cage.pluck(:location).uniq
        @location = singleCageParams[:location]
        if @cage == nil
            redirect_to :controller => "error", :action => "error_404"
        elsif @cage.in_use == false
            gflash :warning => "Cage ##{singleCageParams[:cage_number]} is no longer in use."
            redirect_to root_path
        else
            @gts = %w(\  n/a +/+ +/- -/-)
            @mice = @cage.mice.where(removed:nil)
            @mice.each do |mouse|
                mouse[:parent_cage_id] = ( [nil,"",0].include? mouse[:parent_cage_id] ) ? "n/a" : Cage.find(mouse.parent_cage_id.to_i).cage_number 
            end
            @can_update_remove = @mice.count == 0 ? false : true
            @can_add_pups = @cage.cage_type != 'breeding' ? true : false
            @target_cages = Cage.where(strain:@cage.strain)
        end

    end

    def strain
        @strain = singleStrainParams[:strain]
        @strain2 = nil
        @all_strains = Cage.where(in_use:true).where(strain2:["",nil]).pluck(:strain).uniq
        @all_locations = Cage.pluck(:location).uniq
        @loc = params[:location]
        @type = params[:cage_type]
        if singleStrainParams[:strain].include?("_")
            @strain = singleStrainParams[:strain].split("_")[0]
            @strain2 = singleStrainParams[:strain].split("_")[1]
        elsif 
            singleStrainParams[:strain2] != nil
            @strain2 = singleStrainParams[:strain2]
        else
        end
        @new_cage = Cage.new
        respond_to do |format|
            format.html 
        end
    end

    def strain_table
        @strain = singleStrainParams[:strain]
        @strain2 = nil
        @all_strains = Cage.where(in_use:true).where(strain2:["",nil]).pluck(:strain).uniq
        @all_locations = Cage.pluck(:location).uniq
        @loc = params[:location]
        @type = params[:cage_type]
        if singleStrainParams[:strain].include?("_")
            @strain = singleStrainParams[:strain].split("_")[0]
            @strain2 = singleStrainParams[:strain].split("_")[1]
        elsif 
            singleStrainParams[:strain2] != nil
            @strain2 = singleStrainParams[:strain2]
        else
        end
        respond_to do |format|
            format.html 
            format.json { render json: StrainDatatable.new(params, strain: @strain, strain2: @strain2, location: @loc, cage_type:@type) }
        end
    end

    def update_cage
        @c = Cage.find(params[:id])
        cage_no = @c.cage_number
        log_params = {}
        gts = [nil, "n/a", "+/+", "+/-", "-/-"]
        string_fields = %w(cage_type strain strain2 location cage_number)
        index_fields = %w(genotype genotype2)
        bool_fields = %w(in_use cage_number_changed)
        updateParams = updateCageParams
        @location = (["",nil].include? updateParams[:location]) ? nil : updateParams[:location]
        updateParams.each do |k, v| 
            if bool_fields.include?(k)
                updateParams[k.to_sym] = ActiveModel::Type::Boolean.new.cast(v)
            elsif string_fields.include?(k) && [nil, ""].include?(v)
                updateParams[k.to_sym] = nil
            elsif index_fields.include?(k)
                updateParams[k.to_sym] = v == "" ? "0" : gts.find_index(v).to_s 
            end
        end
        updateParams.each do |k, v|
            if v != nil && @c[k.to_sym] != nil && v != @c[k.to_sym]
                log_params[k.to_sym] = {:priorval => @c[k.to_sym], :newval => v }
            elsif v == nil && @c[k.to_sym] != nil
                log_params[k.to_sym] = {:priorval => @c[k.to_sym], :newval => v }
            elsif v != nil && @c[k.to_sym] == nil
                log_params[k.to_sym] = {:priorval => @c[k.to_sym], :newval => v }
            end
        end
        if @c && @c.update_attributes(updateParams) 
            log_update_cage(@c.cage_number, log_params, current_user)
            if updateCageParams[:in_use] == false
                gflash :success => "Cage #{@c.cage_number} was deleted."
                redirect_to root_path
            else
                gflash :success => "Cage #{@c.cage_number} was successfully updated."
                redirect_to home_cage_path(:cage_number => @c.cage_number, :location => @location)
            end
        else
            gflash :error => "Cage #{cage_no} failed to update.#{@c.errors.full_messages}"
            redirect_to home_cage_path(:cage_number => cage_no)
        end
    end

    def update_mouse
        if params[:removed]
            # Removing a mouse UX has been shifted to a modal, requiring some modification of the controller method. Forking the flow based on the presence of the "removed" parameter.
            @mouse = Mouse.find(params[:mouse][:id])
            cage_number = params[:cage]
            if @mouse
                @mouse.update_attributes(removed:params[:removed], removed_for:params[:removed_for])
                log_remove_mouse(cage_number, @mouse_id, current_user)
                gflash :success => "Mouse was deleted."
                redirect_to home_cage_path(:cage_number => params[:cage])
            else
                gflash :error => "Mouse was not deleted. #{@mouse.errors.full_messages}"
                redirect_to home_cage_path(:cage_number => params[:cage])
            end
        else
            # For all other updating of the cage's mouse attributes
            mouse = params.keys.select{ |k| k.include?("mouse-") }.first
            mouse_id = mouse.split("-").second
            key = params[mouse].keys.first
            val = params[mouse][key.to_sym]
            @mouse = Mouse.find(mouse_id)
            old_value = @mouse[key.to_sym] == nil ? -1 : @mouse[key.to_sym]
            log_params = { :updateattr => key.to_s, :values => { :priorval => old_value, :newval => val } }
            
            respond_to do |format| 
                if key == "designation"
                    if tdc_is_valid?(@mouse, val)
                        tdc = val.scan(/\d+/)
                        @mouse.update_attributes(three_digit_code:tdc.first, designation:val, tdc_generated:Time.now)
                        format.html
                        format.json { render :json => { :message => "Mouse updated" }, :status => :accepted }
                    else
                        format.html
                        format.json { render :json => { :error_message => @mouse.errors.full_messages }, :status => :unprocessable_entity }
                    end
                elsif key == "parent_cage_id"
                    cage_id = Cage.find_by(cage_number:val).id
                    if cage_id
                        @mouse.update_attributes(parent_cage_id:cage_id)
                        log_update_mouse(@mouse, log_params, current_user)
                        format.html
                        format.json { render :json => { :message => "Mouse updated" }, :status => :accepted }
                    else
                        format.html
                        format.json { render :json => { :error_message => @mouse.errors.full_messages }, :status => :unprocessable_entity }
                    end
                elsif @mouse.update_attributes(key.to_sym => val)         
                    log_update_mouse(@mouse, log_params, current_user)
                    format.html
                    format.json { render :json => { :message => "Mouse updated" }, :status => :accepted }
                else
                    format.html
                    format.json { render :json => { :error_message => @mouse.errors.full_messages }, :status => :unprocessable_entity }
                end
            end
        end
    end

    def remove_mouse
        @mouse = Mouse.find(removeMouseParams[:mouse_id])
        cage_number = @mouse.cage.cage_number
        date_val = removeMouseParams[:remove_date]
        reason_val = (["",nil].include? removeMouseParams[:remove_reason]) ? nil : removeMouseParams[:remove_reason]
        respond_to do |format|
            if ["", nil].include? date_val
                gflash :error => "Mouse was not removed from cage. Removal Date is required."
                format.html
                format.json { render :json => { :message => "No date "}, :status => :unprocessable_entity }
            else
                @mouse.update_attributes(removed: date_val, removed_for: reason_val)  
                log_remove_mouse(cage_number, @mouse.id, current_user)
                gflash :success => "Mouse was successfully removed"
                format.html 
                format.json { render :json => { :message => "Mouse removed" }, :status => :ok }
            end
        end
    end

    def mouse
        puts params.to_json
        @mouse = Mouse.find(params[:mouse])
        respond_to do |format|
            format.html
            format.json { render :json => { :message => "Mouse found", :data => @mouse }, :status => :ok }
        end
    end

    def update_tail_cut_date
        mouse = params.keys.select{ |k| k.include?("mouse-") }.first
        mouse_id = mouse.split("-").second
        key = params[mouse].keys.first
        date_val = params[mouse][key.to_sym]
        @mouse = Mouse.find(mouse_id)
        old_value = @mouse[key.to_sym] == nil ? -1 : @mouse[key.to_sym]
        log_params = { :updateattr => key.to_s, :values => { :priorval => old_value, :newval => date_val } }

        respond_to do |format|
            if validate_date(date_val)
                @mouse.update_attributes(key.to_sym => date_val)
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
        puts params
        cage_id = params[:cage].to_i
        @cage = Cage.find(cage_id)
        strain = @cage.strain
        strain2 = @cage.strain2
        successful_saves = 0
        error_messages = []
        params[:pups].to_i.times.each do |p|
           @m = Mouse.new(sex:nil, dob:params[:birthdate], parent_cage_id:cage_id, cage_id: cage_id, strain:strain, strain2:strain2)
            if @m.save
                successful_saves += 1
            else
                error_messages.push(@m.errors.full_messages)
            end
        end
        if successful_saves > 0
            log_new_pups(@cage.cage_number, "#{successful_saves} pups", current_user)
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

    def restore_mouse
        puts restoreMouseParams
        if restoreMouseParams[:mouse].to_i.to_s == restoreMouseParams[:mouse]
            begin
                @mouse = Mouse.find(restoreMouseParams[:mouse])
                @mouse.update_attributes(removed: nil, removed_for: nil)
                respond_to do |format|
                    format.html
                    format.json { render :json => { :message => "Mouse was restored to cage #{@mouse.cage.cage_number}.", :status => :accepted } }
                end
            rescue ActiveRecord::RecordNotFound

            end
        else
            respond_to do |format|
                format.html
                format.json { render :json => { :message => "Mouse was not restored. Please see a site administrator.", :status => :unprocessable_entity } }
            end
        end
    end

    def removed_mouse_index
        respond_to do |format|
            format.html 
            format.json { render json: RemovedMiceDatatable.new(params) }
        end
    end

    def graph_data_sex
        strain = graphDataParams[:strain].include?("_") ? graphDataParams[:strain].split("_").first : graphDataParams[:strain]
        strain2 = graphDataParams[:strain].include?("_") ? graphDataParams[:strain].split("_").second : ["",nil]
        single_sex_cage_ids = Cage.where(cage_type:["single-m","single-f"]).where(location:graphDataParams[:location]).pluck(:id)
        @mice = Mouse.where(strain:strain).where(strain2:strain2).where(removed:["", nil]).where(cage_id:single_sex_cage_ids)
        render :json => { :numbers => [@mice.where(sex:1).count, @mice.where(sex:2).count], :status => :ok }
    end

    def graph_data_age
        strain = graphDataParams[:strain].include?("_") ? graphDataParams[:strain].split("_").first : graphDataParams[:strain]
        strain2 = graphDataParams[:strain].include?("_") ? graphDataParams[:strain].split("_").second : ["",nil]
        location = graphDataParams[:location]
        graph_strain = graphDataParams[:strain].include?("_") ? "#{strain}/#{strain2}" : "#{strain}"

        @mice = Mouse.where(strain:strain).where(strain2:strain2).where(removed:["",nil]).joins(:cage).where(:cages => {:cage_type => ['single-f', 'single-m'], :in_use => true, :location => location }) #add filter for cage_type here

        # create an empty matrix and add the category descriptors (required by the graph API) and the top-line data points in this format: [category ID, category parent, quantity of mice in the category, secondary data point]
        array = []
        array.push(['Container', 'Parent', 'Cage Count', 'Other Category'])
        array.push([graphDataParams[:strain].include?("_") ? "#{strain}/#{strain2}" : "#{strain}", nil, @mice.count ,0])

        cage_types = %w(single-f single-m)
        age_ranges = [[0,3],[3,6],[6,9],[9,12],[12,15],[15,20],[20,24]]
        cage_types.each do |c|
            @cages = Cage.where(cage_type:c).where(strain:strain).where(strain2:strain2).where(in_use:true).where(location:location)
            array.push([c,graph_strain,@mice.where(cage_id:@cages.pluck(:id)).where(removed:[nil,""]).where(["dob <= ?", Date.today]).where(["dob > ?", 24.months.ago]).count,@cages.count])
            age_ranges.each do |r|
                cage_ids = Mouse.where(["dob <= ?", r[0] == 0 ? Date.today : r[0].months.ago]).where(["dob > ?", r[1].months.ago]).where(removed:[nil,""]).joins(:cage).where(:cages => {:cage_type => c, :strain => strain, :strain2 => strain2, :in_use => true, :location => location}).pluck(:cage_id).uniq
                mice_count = Mouse.where(["dob <= ?", r[0] == 0 ? Date.today : r[0].months.ago]).where(["dob > ?", r[1].months.ago]).where(removed:[nil,""]).joins(:cage).where(:cages => {:cage_type => c, :strain => strain, :strain2 => strain2, :in_use => true, :location => location}).count
                puts "#{r}: #{c}: #{cage_ids}"
                array.push([ "#{r[0]}-#{r[1]} months, #{c}",c,mice_count,cage_ids.count])
                cage_ids.each do |i|
                    suffix = "#{c == 'single-f' ? 'sf' :  c == 'single-m' ? 'sm' : 'ex'}#{r[0]}-#{r[1]}m"
                    array.push(["#{Cage.find(i).cage_number}|#{suffix}", "#{r[0]}-#{r[1]} months, #{c}", Mouse.where(['dob <= ?', r[0] == 0 ? Date.today : r[0].months.ago]).where(['dob > ?', r[1].months.ago]).where(removed:[nil,'']).joins(:cage).where(:cages => {:id => i}).count, i ])

                end

            end
        end
        render :json => { :data => array, :status => :ok }

    end

    def cage_timeline_dates
        @cage = Cage.find_by(cage_number:cageTimelineParams[:cage])
        @archives = Archive.where(cage:cageTimelineParams[:cage]).where(acttype:["New Cage","New Pups"]).order(:created_at)
        if @cage.cage_type == "single-m" || @cage.cage_type == "single-f"
            @archives = Archive.where(cage: cageTimelineParams[:cage]).where(acttype:["New Cage", "New Pups"]).or(Archive.where(acttype:"Xfer Mouse").where(newval:cageTimelineParams[:cage])).order(:created_at)
        end 
        timeline = @archives.map{ |a| a.acttype == "Xfer Mouse" ? {"second": a.created_at.to_time.to_i,"title":"#{a.acttype} from cage #{a.priorval}"} : {"second": a.created_at.to_time.to_i,"title":a.acttype} }
        render :json => { :timepoints => timeline }

    end

    private

    def singleCageParams
        params.permit(:cage_number, :location)
    end

    def singleStrainParams
        params.permit(:strain, :strain2, :location, :cage_type)
    end

    def createCageParams
        params.require(:cage).permit(:cage_number, :strain, :strain2, :cage_type, :location, :genotype, :genotype2)
    end

    def updateCageParams
        params.require(:cage).permit(:cage_number, :strain, :strain2, :genotype, :genotype2, :cage_type, :location, :in_use)
    end

    def removeCageParams
    end

    def removeMouseParams
        params.require(:mouse).permit(:mouse_id, :remove_date, :remove_reason)
    end

    def updateMouseParams
        params.permit(:genotype)
    end

    def newPupsParams 
        params.permit(:pups, :birthdate)
    end

    def restoreMouseParams
        params.permit(:mouse)
    end

    def graphDataParams
        params.permit(:strain, :location)
    end

    def cageTimelineParams
        params.permit(:cage)
    end
end

=begin
algorithm for pulling and organizing mouse and cage data points for the treemap

All the data points are mouse counts. The tree branches (blocks) are essentially filters

The first filter is living/dead
Second filter is matching strain
third filter is cage type (breeding, single, experiment)
fourth is age-range


                                                                                                                    Living
                                                                                                                       |
                                                                                                                    Strain
                                                                                                                       |
                                        Cage-type:          breeding            single                experiment  

=end