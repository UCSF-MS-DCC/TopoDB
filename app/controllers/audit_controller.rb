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

    def cage
        respond_to do |format|
            format.html
            format.json { render json: CageAuditDatatable.new(params)}
        end
    end

    def mouse_version
        id = params[:id].to_i
        @mouse = Mouse.find(id)
        @versions = Mouse.find(id).versions.where.not(object:nil)
        @versions = @versions.sort_by { |v| v[:transaction_id] }.reverse
    end

    def cage_version
        id = params[:id].to_i
        @cage = Cage.find(id)
        @versions = Cage.find(id).versions.where.not(object:nil)
        @versions = @versions.sort_by { |v| v[:transaction_id] }.reverse
    end

    def restore_mouse_version
        current = Mouse.find(params[:mouse_id].to_i)
        revert = current.versions[restore_mouse_version_params[:version].to_i].reify
        if revert.save
            gflash :success => "Mouse #{revert[:id]} was successfully reverted"
        else
            gflash :error => "Mouse #{revert[:id]} was not reverted. Errors: #{revert.errors.full_messages}"
        end
        redirect_to audit_index_path
    end
    def restore_cage_version
        puts "Restore Cage params: #{restore_cage_version_params.to_json}"
        current = Cage.find(params[:cage_id].to_i)
        revert = current.versions[restore_cage_version_params[:version].to_i].reify
        if revert.save
            gflash :success => "Cage #{revert[:id]} was successfully reverted"
        else
            gflash :error => "Cage #{revert[:id]} was not reverted. Errors: #{revert.errors.full_messages}"
        end
        redirect_to audit_index_path
    end

    private

        def restore_mouse_version_params
            params.permit(:mouse_id, :version)
        end
        def restore_cage_version_params
            params.permit(:cage_id, :version)
        end


end