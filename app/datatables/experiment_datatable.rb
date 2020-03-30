class ExperimentDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      date: { source: "Experiment.date" },
      name: { source: "Experiment.name" },
      gene: { source: "Experiment.gene" },
      description: { source: "Experiment.description" },
      id: { source: "Experiment.id" }
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        date: record.date,
        name: record.name,
        gene: record.gene,
        description: record.description.length <= 30 ? record.description : "#{record.description[0..29]}...",
        id: record.id
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    Experiment.all.order("date DESC")
    # insert query here
    # User.all
  end

end
