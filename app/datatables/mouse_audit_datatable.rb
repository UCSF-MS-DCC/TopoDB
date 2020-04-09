class MouseAuditDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Mouse.id" },
      cage: { source: "Cage.cage_number"},
      identifier: { source: "Mouse.three_digit_code" },
      versions: { source: "Mouse.id"},
      last_update: { source: "Mouse.id"},
      last_event: { source: "Mouse.id"},
      who: { source: "Mouse.id"}
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        id: record.decorate.link_to_mouse,
        cage: record.cage.cage_number,
        identifier: "#{["","F","M"][record.sex.to_i]}#{record.three_digit_code}#{["","-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"][record.ear_punch.to_i]}",
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
    Mouse.all.order("updated_at DESC")
    # insert query here
    # User.all
  end

end
class MouseDecorator < ApplicationDecorator
  def link_to_mouse
    h.link_to object.id, h.audit_mouse_version_path(id: object.id)
  end

end
