class StrainDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      cage_number:            { source:"Cage.cage_number" },
      cage_type:              { source:"Cage.cage_type" },
      genotype:               { source:"Cage.genotype" },
      dob:                    { source:"Cage.cage_number"},
      number_mice:            { source:"Cage.id"}
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    gts = %w(\  n/a +/+ +/- -/-)
    records.map do |record|
      {
        cage_number:            record.decorate.link_to_cage,
        cage_type:              record.cage_type,
        genotype:               (record.genotype == nil || record.genotype == "" || record.genotype == "0") ? "" : ( (record.genotype2 == nil || record.genotype2 == "" || record.genotype2 == "0") ? gts[record.genotype.to_i] : "#{gts[record.genotype.to_i]} | #{gts[record.genotype2.to_i]}" ),
        dob:                    record.cage_type != 'breeding' ? ( record.mice.where(removed:nil).where.not(dob:nil).count > 0 ? record.mice.where(removed:nil).where.not(dob:nil).order(dob: :asc).last[:dob].strftime("%Y-%m-%d") : "") : "",
        number_mice:            record.cage_type != 'breeding' ? record.mice.where(removed:nil).count : ""
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    
    records = nil
    if options[:strain2] && ![nil, ""].include?(options[:strain2]) 
      records = Cage.where(strain:options[:strain]).where(strain2:options[:strain2]).where(in_use:true)
    else
      records = Cage.where(strain:options[:strain]).where(strain2:[nil, ""]).where(in_use:true)
    end
    records
    # insert query here
    # User.all
  end

end
class CageDecorator < ApplicationDecorator
  def link_to_cage
    h.link_to object.cage_number, h.home_cage_path(:cage_number => object.cage_number)
  end

end