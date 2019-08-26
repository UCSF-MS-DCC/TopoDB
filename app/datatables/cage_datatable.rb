class CageDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      cage_number:            { source:"Cage.cage_number" },
      strain:                 { source:"Cage.strain" },
      genotype:               { source:"Cage.genotype"},
      location:               { source:"Cage.location"},
      cage_type:              { source:"Cage.cage_type" }
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    gts = %w(+/+ +/- -/+ -/-)
    records.map do |record|
      {
        cage_number:            record.decorate.link_to_cage,
        strain:                 (record.strain2 == nil || record.strain2 == "") ? record.decorate.link_to_strain : record.decorate.link_to_hybrid_strain,
        genotype:               (record.genotype == nil || record.genotype == "") ? "" : ( (record.genotype2 == nil || record.genotype2 == "") ? gts[record.genotype.to_i - 2] : "#{gts[record.genotype.to_i - 2]} | #{gts[record.genotype2.to_i - 2]}"),
        location:               record.location.capitalize,
        cage_type:              record.cage_type
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    Cage.all.where.not(in_use:false)
    # insert query here
    # User.all
  end

end

class CageDecorator < ApplicationDecorator
  def link_to_cage
    h.link_to object.cage_number, h.home_cage_path(:cage_number => object.cage_number)
  end

  def link_to_strain
    h.link_to object.strain, h.home_strain_path(:strain => object.strain)
  end

  def link_to_hybrid_strain
    h.link_to "#{object.strain} / #{object.strain2}", h.home_strain_path(:strain => "#{object.strain}_#{object.strain2}")
  end
end