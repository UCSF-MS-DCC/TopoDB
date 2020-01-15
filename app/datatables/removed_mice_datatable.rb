class RemovedMiceDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      cage:               { source: "Mouse.cage_id"},
      designation:        { source: "Mouse.designation" },
      strain:             { source: "Mouse.strain" },
      sex:                { source: "Mouse.sex" },
      genotype:           { source: "Mouse.genotype" },
      removed:            { source: "Mouse.removed" },
      removed_for:        { source: "Mouse.removed_for" },
      restore:            { source: "Mouse.id"}

      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      gts = %w(\  n/a +/+ +/- -/-)
      sx = %w(nil F M)
      {
        cage:             Cage.find(record.cage_id).cage_number,
        designation:      "#{[nil,"F","M"][record.sex.to_i]}#{(["",nil].include? record.three_digit_code) ? "-no id #-" : record.three_digit_code}#{(["",nil].include? record.ear_punch) ? "-no-ear-notch-" : [nil,"-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"][record.ear_punch.to_i] }",
        strain:           (record.strain2 != nil && record.strain2 != "") ? "#{record.strain}/#{record.strain2}" : record.strain ,
        sex:              sx[record.sex.to_i],
        genotype:         (record.genotype2 == "" || record.genotype2 == nil || record.genotype2 == "0") ? gts[record.genotype.to_i] : "#{gts[record.genotype.to_i]} | #{gts[record.genotype2.to_i]}",
        removed:          record.removed,
        removed_for:      record.removed_for,
        restore:          record.decorate.transfer_select
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
class MouseDecorator < ApplicationDecorator
  def transfer_select
    h.best_in_place object, :removed, as: :checkbox, collection: {false: "No", true: "Yes"}, :url => '/home/update_mouse_cage'
  end

  def bip_transfer_select
    sx = ["f", "m"][(object.sex.to_i - 1)]
    col = [[1,12345],[2,45678],[3,78901]]
    h.best_in_place(object, :cage_id, :as => :select, :collection => col , :url =>'/home/update_mouse_cage', :html_attrs => { :selected => col.first }, :param => object.id)
  end
end
#Cage.where(strain:object.strain).where(cage_type:["experimental", "single-#{sx}"]).where(in_use:true).map{ |cg| ["#{cg.id}", "#{cg.strain} #{@genotypes[cg.genotype.to_i]}: #{cg.cage_number} (#{cg.cage_type})"]
# [nil,"-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"]