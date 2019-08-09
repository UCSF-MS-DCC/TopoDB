class ArchiveDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      date:           { source:"Archive.created_at" },
      time:           { source:"Archive.created_at"},
      user:           { source:"Archive.id"},
      description:    { source:"Archive.id"}

      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        date:           record.created_at.strftime("%Y-%m-%d"),
        time:           record.created_at.strftime("%l:%M %p"),
        user:           parseUser(record.id),
        description:    parseDesc(record.id)

        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  def get_raw_records
    Archive.all.order("created_at DESC")
    # insert query here
    # User.all
  end

  private

    def parseDesc(id)
      @arc = Archive.find(id)
      desc = ""
      if @arc.acttype == "Xfer Mouse"
        desc = "Transfered mouse #{@arc.objdsn} from cage #{@arc.priorval} to cage #{@arc.newval}"
      elsif @arc.acttype == "New Cage"
        desc = "Added new #{Cage.find_by(cage_number:@arc.objdsn).cage_type} cage #{@arc.objdsn} for strain #{@arc.newval}"
      elsif @arc.acttype == "New Pups"
        desc = "Added #{@arc.newval} pups to cage #{@arc.objdsn}"
      else
      end
      desc
    end

    def parseUser(id)
      @arc = Archive.find(id)
      @u = User.find(@arc.who)
      "#{@u.first} #{@u.last}"
    end
end

