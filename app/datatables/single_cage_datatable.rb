class SingleCageDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {

      genotype:           { source: "Mouse.genotype" },
      designation:        { source: "Mouse.designation" },
      parent_cage_id:     { source: "Mouse.parent_cage_id" },
      weaning_date:       { source: "Mouse.weaning_date" }


      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        genotype:             record.genotype,
        designation:          record.designation,
        parent_cage_id:       record.parent_cage_id,
        weaning_date:         record.weaning_date
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    puts "datatable options #{options.to_json}"
    Mouse.where(cage_id:Cage.find_by(:cage_number => options[:cage_number]).id)
    # insert query here
    # User.all
    # Mouse.all
  end

end
    # t.bigint "cage_id"
    # t.string "sex"
    # t.string "genotype"
    # t.date "dob"
    # t.date "weaning_date"
    # t.date "tail_cut_date"
    # t.string "ear_punch"
    # t.string "designation"
    # t.boolean "dead"
    # t.text "notes"
    # t.string "on_experiment"
    # t.integer "parent_cage_id"
    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false
    # t.string "strain"
    # t.string "origin"