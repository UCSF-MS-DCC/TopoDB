class CageDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      cage_number:            { source:"Cage.cage_number" },
      strain:                 { source:"Cage.strain" },
      location:               { source:"Cage.location"},
      cage_type:              { source:"Cage.cage_type" },
      expected_weaning_date:  { source:"Cage.expected_weaning_date" }
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        cage_number:            record.decorate.link_to_cage,
        strain:                 record.decorate.link_to_strain,
        location:               record.location.capitalize,
        cage_type:              record.cage_type,
        expected_weaning_date:  record.cage_type == 'breeding' ? record.expected_weaning_date : '-'
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

class CageDecorator < ApplicationDecorator
  def link_to_cage
    h.link_to object.cage_number, h.home_cage_path(:cage_number => object.cage_number)
  end

  def link_to_strain
    h.link_to object.strain, h.home_strain_path(:strain => object.strain)
  end
end