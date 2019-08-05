class StrainDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      cage_number:            { source:"Cage.cage_number" },
      location:               { source:"Cage.location"},
      cage_type:              { source:"Cage.cage_type" },
      sex:                    { source:"Cage.sex" },
      expected_weaning_date:  { source:"Cage.expected_weaning_date" }
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        cage_number:            record.decorate.link_to_cage,
        location:               record.location.capitalize,
        cage_type:              record.cage_type,
        sex:                    record.cage_type == 'breeding' ? "#{record.mice.where(sex:'M').count}M, #{record.mice.where(sex:'F').count}F" : "#{record.mice.count}#{record.sex}",
        expected_weaning_date:  record.cage_type == 'breeding' ? record.expected_weaning_date : '-'
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    Cage.where(strain:options[:strain])
    # insert query here
    # User.all
  end

end
class CageDecorator < ApplicationDecorator
  def link_to_cage
    h.link_to object.cage_number, h.home_cage_path(:cage_number => object.cage_number)
  end

end