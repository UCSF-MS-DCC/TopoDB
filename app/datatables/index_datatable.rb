class IndexDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      strain:         { source: "Cage.strain" },
      cages:          { source: "Cage.id" },
      mice:           { source: "Cage.id" },
      last_active:    { source: "Cage.updated_at" }
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end
# TODO: include hybrid strains

  def data
    strains = Cage.where(in_use:true).pluck(:strain).uniq.sort
    puts "STRAINS: #{strains}"
    strains.map do |record|
      {
        strain:         record.decorate.link_to_strain,
        cages:          Cage.where(strain:record).where(in_use:true).count,
        mice:           Mouse.where(strain:record).where(removed:nil).count,
        last_active:    Cage.where(strain:record).sort_by(&:updated_at).last.updated_at > Mouse.where(strain:record).sort_by(&:updated_at).last.updated_at ? Cage.where(strain:record).sort_by(&:updated_at).last.updated_at.strftime('%Y-%m-%d @ %l:%M %P') : Mouse.where(strain:record).sort_by(&:updated_at).last.updated_at.strftime('%Y-%m-%d @ %l:%M %P')
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    Cage.all
    # insert query here
    # User.all
  end

end
