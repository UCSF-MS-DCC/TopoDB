class CageAuditDatatable < AjaxDatatablesRails::ActiveRecord
    def view_columns
      # Declare strings in this format: ModelName.column_name
      # or in aliased_join_table.column_name format
      @view_columns ||= {
        id: { source: "Cage.id" },
        in_use: { source: "Cage.in_use"},
        location: { source: "Cage.location"},
        cage_number: { source: "Cage.cage_number"},
        transgenic_line: { source: "Cage.strain"},
        versions: { source: "Mouse.id"},
        last_update: { source: "Mouse.id"},
        last_event: { source: "Mouse.id"},
        who: { source: "Mouse.id"}
      }
    end
  
    def data
      records.map do |record|
        {
          id: record.decorate.link_to_cage,
          in_use: record.in_use == true ? "In Use" : "Removed",
          location: record.location,
          cage_number: record.cage_number,
          transgenic_line: (record.strain2.blank?) ? record.strain : "#{record.strain}/#{record.strain2}",
          versions: record.versions.where.not(object:nil).size,
          last_update: record.versions.last.created_at.strftime("%Y-%m-%d, %l:%M %P"),
          last_event: record.versions.last.event,
          who: User.find(record.versions.last.whodunnit).first
          # example:
          # id: record.id,
          # name: record.name
        }
      end
    end
  
    def get_raw_records
      Cage.all.order("updated_at DESC")
      # insert query here
      # User.all
    end
  
  end
  class CageDecorator < ApplicationDecorator
    def link_to_cage
      h.link_to object.id, h.audit_cage_version_path(id: object.id)
    end
  
  end
