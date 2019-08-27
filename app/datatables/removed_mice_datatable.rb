class RemovedMiceDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      cage:               { source: "Mouse.cage_id"},
      designation:        { source: "Mouse.designation" },
      strain:             { source: "Mouse.strain" },
      genotype:           { source: "Mouse.genotype" },
      removed:            { source: "Mouse.removed" },
      removed_for:        { source: "Mouse.removed_for" }

      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      gts = %w(\  n/a +/+ +/- -/+ -/-)
      {
        cage:             Cage.find(record.cage_id).cage_number,
        designation:      record.designation,
        strain:           (record.strain2 != nil && record.strain2 != "") ? "#{record.strain}/#{record.strain2}" : record.strain ,
        genotype:         (record.genotype2 == "" || record.genotype2 == nil || record.genotype2 == "0") ? gts[record.genotype.to_i] : "#{gts[record.genotype.to_i]} | #{gts[record.genotype2.to_i]}",
        removed:          record.removed,
        removed_for:      record.removed_for
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    Mouse.where.not(removed:nil)
    # insert query here
    # User.all
  end

end
