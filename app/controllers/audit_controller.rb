class AuditController < ApplicationController
    before_action :authenticate_user!

    def index 


    end

    def show

    end

    def mouse
        respond_to do |format|
            format.html
            format.json { render json: MouseAuditDatatable.new(params) }
        end
    end

    def mouse_version
        id = params[:id].to_i
        @mouse = Mouse.find(id)
        @versions = Mouse.find(id).versions.where.not(object:nil).order("transaction_id DESC")
        puts @versions.size
        puts @versions.is_a? Array
    end

    def restore_mouse_version
        puts "Restore Mouse params: #{restore_mouse_version_params.to_json}"
        current = Mouse.find(params[:mouse_id].to_i)
        revert = current.versions[restore_mouse_version_params[:version].to_i].reify

        puts "CURRENT STATE: #{current.to_json}"
        puts "REVERTED STATE: #{revert.to_json}"

        if revert.save
            gflash :success => "Mouse #{revert[:id]} was successfully reverted"
        else
            gflash :error => "Mouse #{revert[:id]} was not reverted. Errors: #{revert.errors.full_messages}"
        end

        redirect_to audit_index_path
    end


    private

        def restore_mouse_version_params
            params.permit(:mouse_id, :version)
        end


end