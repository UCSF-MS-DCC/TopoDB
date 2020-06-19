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
    @dob_val = nil
    records.map do |record|
      if record.cage_type == "breeding"
        @dob_val = record.mice.where(removed:nil).where(sex:2).where(["dob < ?", Date.today - 21 ]).count > 0 ? "M: #{record.mice.where(removed:nil).where(sex:2).where(["dob < ?", Date.today - 21 ]).first.dob.strftime("%m-%d-%Y")}" : ""
        if record.mice.where(removed:nil).where(sex:1).where(["dob < ?", Date.today - 21 ]).size == 1
          @dob_val += ", F: #{record.mice.where(removed:[nil,""]).where(sex:1).where(["dob < ?", Date.today - 21 ]).first.dob.strftime("%m-%d-%Y")}"
        elsif record.mice.where(removed:nil).where(sex:1).where(["dob < ?", Date.today - 21 ]).size >= 2
          @dob_val += ", F1: #{record.mice.where(removed:[nil,""]).where(sex:1).where(["dob < ?", Date.today - 21 ]).first.dob.strftime("%m-%d-%Y")}, F2: #{record.mice.where(removed:[nil,""]).where(sex:1).where(["dob < ?", Date.today - 21 ]).second.dob.strftime("%m-%d-%Y")}"
        end
      elsif record.cage_type == "single-f" || record.cage_type == "single-m"
        @dob_val = record.mice.where(removed:nil).pluck(:dob).uniq.join(", ")
      else
        "-"
      end
      {
        cage_number:            record.decorate.link_to_cage,
        cage_type:              record.cage_type,
        genotype:               (record.genotype == nil || record.genotype == "" || record.genotype == "0") ? "" : ( (record.genotype2 == nil || record.genotype2 == "" || record.genotype2 == "0") ? gts[record.genotype.to_i] : "#{gts[record.genotype.to_i]} | #{gts[record.genotype2.to_i]}" ),
        dob:                    @dob_val,
        number_mice:            record.cage_type != 'breeding' ? record.mice.where(removed:nil).count : record.mice.where(removed:nil).where(["dob >= ?", Date.today - 21]).count
      }
    end
  end

  def get_raw_records
    records = nil
    if options[:strain2].present?
      records = Cage.where(strain:options[:strain]).where(strain2:options[:strain2]).where(location:options[:location]).where(["cage_type LIKE ? ","%#{options[:cage_type]}%"]).where(in_use:true)
    else
      records = Cage.where(strain:options[:strain]).where(strain2:[nil, ""]).where(location:options[:location]).where(["cage_type LIKE ? ","%#{options[:cage_type]}%"]).where(in_use:true)
    end
    records
    # insert query here
    # User.all
  end

end
class CageDecorator < ApplicationDecorator
  def link_to_cage
      h.link_to object.cage_number, h.cage_path(:id => object.id)
  end
end
#record.mice.where(removed:nil).where(sex:1).where(["dob < ?", Date.today - 21 ]).second.dob.strftime("%m-%d-%Y") : "n/a"