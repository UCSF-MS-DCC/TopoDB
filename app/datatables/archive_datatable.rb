class ArchiveDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      date:           { source:"Archive.created_at" },
      time:           { source:"Archive.created_at" },
      user:           { source:"Archive.id" },
      description:    { source:"Archive.id" }

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
      gts = [nil, "n/a", "+/+", "+/-", "-/+", "-/-"]
      desc = ""
      if @arc.acttype == "New Cage"
        desc = "New cage ##{@arc.cage} created."
      elsif @arc.acttype == "Update Cage"
        desc = "Cage ##{@arc.cage} was updated: #{@arc.changed_attr} was changed from #{@arc.changed_attr.include?("genotype") ? (@arc.priorval == "0" ? "null" : gts[@arc.priorval.to_i]) : @arc.priorval} to #{@arc.changed_attr.include?("genotype") ? (@arc.newval == "0" ? "null" : gts[@arc.newval.to_i]) : @arc.newval}"
      elsif @arc.acttype == "Remove Cage"
        desc = "Cage ##{@arc.cage} was removed."
      elsif @arc.acttype == "New Pups"
        desc = "Cage ##{@arc.cage}: #{@arc.newval} were added"
      elsif @arc.acttype == "New Mouse ID"
        desc = "Cage ##{@arc.cage}: IDs #{@arc.newval} assigned to pups."
      elsif @arc.acttype == "Remove mouse"
        desc = "Mouse #{genMouseIDString(@arc.mouse.to_i)} was removed from Cage ##{@arc.cage}"
      elsif @arc.acttype == "Update Mouse"
        desc = "Mouse #{Mouse.find(@arc.mouse.to_i).designation} in Cage ##{@arc.cage} was updated: #{@arc.changed_attr} changed from #{@arc.priorval} to #{@arc.newval}"
      elsif @arc.acttype == "Tail Cut Date"
        desc = "Mouse #{Mouse.find(@arc.mouse.to_i).designation} in Cage ##{@arc.cage} tail cut date was set to #{@arc.newval}"
      elsif @arc.acttype == "Xfer Mouse"
        desc = "Mouse #{Mouse.find(@arc.mouse.to_i).designation} was transfered from Cage ##{@arc.priorval} to Cage ##{@arc.newval}"
      elsif @arc.acttype == "Reason for Mouse Removal"
        desc = "Mouse #{Mouse.find(@arc.mouse.to_i).designation} reason for removal: #{@arc.newval}"
      end
    end

    def parseUser(id)
      @arc = Archive.find(id)
      @u = User.find(@arc.who)
      "#{@u.first} #{@u.last}"
    end

    def genMouseIDString(id)
      @m = Mouse.find(id)
      sex = (["",nil].include? @m.sex) ? "|no sex|" : [nil,"F","M"][@m.sex.to_i]
      tdc = (["",nil].include? @m.three_digit_code) ? "|no id|" : @m.three_digit_code
      ear = (["",nil].include? @m.ear_punch) ? "|no ear punch|" : [nil,"-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"][@m.ear_punch.to_i]

      "#{sex}#{tdc}#{ear}"
    end
end

