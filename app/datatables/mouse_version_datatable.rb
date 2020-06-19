class MouseVersionDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      version: { source: "Mouse.id"},
      sex: { source: "Mouse.sex"},
      mouse_id: { source: "Mouse.three_digit_code"},
      ear_punch: { source: "Mouse.ear_punch"},
      t_line: { source: "Mouse.strain"},
      genotype: { source: "Mouse.genotype"},
      cage: { source: "Mouse.id"},
      experiment: { source: "Mouse.id"},
      who: { source: "Mouse.id"}
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    puts "RECORDS: #{records}"
    records.map do |record|
      record = record.reify
      {
        version: record.transaction_id,
        sex: record.sex,
        mouse_id: record.three_digit_code,
        ear_punch: record.ear_punch,
        t_line: record.strain,
        genotype: record.genotype,
        cage: record.cage.cage_number,
        experiment: record.experiment.name,
        who: record.whodunnit
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records #REIFY???
    @mouse = Mouse.find(options[:mouse_id].to_i)
    versions = @mouse.versions

    # insert query here
    # User.all
  end

end
