class CageController < ApplicationController
    before_action :authenticate_user!
    def index
        @strain = params[:strain]
        @strain2 = nil
        @all_strains = Cage.where(in_use:true).where(strain2:["",nil]).pluck(:strain).uniq
        @all_locations = Cage.pluck(:location).uniq
        @loc = params[:location]
        @type = params[:cage_type]
        if params[:strain].include?("_")
            @strain = params[:strain].split("_")[0]
            @strain2 = params[:strain].split("_")[1]
        elsif 
            params[:strain2] != nil
            @strain2 = params[:strain2]
        else
        end
        @new_cage = Cage.new
        respond_to do |format|
            format.html 
        end
    end

    def show
        @cage = Cage.find(params[:id])
        if !@cage.in_use
            redirect_to cage_index_path(:location => @cage.location, :strain => @cage.strain)
        end
        @cage.update_last_viewed
        @strains = Cage.where(in_use:true).where(strain2:["",nil]).pluck(:strain).uniq
        @strain = (@cage.strain2.blank?) ? @cage.strain : "#{@cage.strain}_#{@cage.strain2}"
        @location = @cage.location
        @new_mouse = Mouse.new
        @all_strains = Cage.pluck(:strain).uniq
        @genotypes_list = [nil, "n/a", "+/+", "+/-", "-/-"]
    end

    def new
        @cage = Cage.new
    end

    def create
    end

    def create_pups
        errors = []
        pups = 0
        params[:pups].to_i.times do 
            @mouse = Mouse.new(cage_id: params[:cage_id], dob: params[:birthdate], pup:true, parent_cage_id:params[:cage_id])
            if @mouse.save
                pups += 1
            else
                errors.push(@mouse.errors)
            end
        end
        if errors.size < 1
            gflash :success => "#{pups} pups added to cage #{Cage.find(params[:cage_id]).cage_number}"
        else
            gflash :error => "#{errors}"
        end
        redirect_to action: "show", id: params[:cage_id]
    end

    def edit
    end

    def update
        cage = Cage.find(params[:id])
        update_params = create_and_update_params
        puts update_params
        if cage.update_attributes(update_params) 
            gflash :success => "Cage #{cage.cage_number} was successfully updated."
        else
            gflash :error => "Cage #{cage.cage_number} failed to update.#{cage.errors.full_messages}"
        end
        redirect_to action: "show", id: cage.id
    end

    def destroy
    end

    def file_store
        cage = Cage.find(params[:cage_id])
        unless upload_file_params[:attachments].empty?
            if cage.attachments.attach(upload_file_params[:attachments])
                gflash :success => "Files uploaded successfully"
            else
                gflash :error => "Files failed to upload"
            end
        end
        redirect_to action: "show", id: cage.id
    end

    def download_file 
        puts params
        @cage = Cage.find(params[:cage_id])
        @attachment = @cage.attachments.find_by(id:params[:attachment_id])
        @attachment.open(tmpdir:"#{Rails.root}/public") do |file|
            send_file(file, filename: @attachment.filename)
        end
        redirect_to action: "show", id: params[:cage_id]
    end

    def delete_attachment
        @cage = Cage.find(params[:cage_id])
        @attachment = @cage.attachments.find_by(id:params[:attachment_id])
        @attachment.purge
        if !@cage.attachments.find_by(id:params[:attachment_id])
            gflash :success => "File #{@attachment.filename} was deleted."
        else
            gflash :error => "There was a problem deleting #{@attachment.filename}."
        end
        redirect_to action: "show", id: @cage.id
    end

    private 

        def create_and_update_params
            params.require(:cage).permit(Cage.column_names.select{ |col| ![:updated_at, :created_at].include? col }.map{ |col| col.to_sym })
        end
        
        def upload_file_params
            params.require(:cage).permit(attachments:[])
        end
end