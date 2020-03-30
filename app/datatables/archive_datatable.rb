class ArchiveDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      date:           { source:"Archive.created_at" },
      time:           { source:"Archive.created_at" },
      user:           { source:"Archive.id" },
      description:    { source:"Archive.id" }
    }
  end

  def data
    records.map do |record|
      {
        date:           record.created_at.strftime("%Y-%m-%d"),
        time:           record.created_at.strftime("%l:%M %p"),
        user:           parseUser(record.id),
        description:    parseDesc(record.id)
      }
    end
  end

  def get_raw_records
    Archive.all.order("created_at DESC")
  end

  private

  def parseDesc(id)
    @arc = Archive.find(id)
    gts = [nil, "n/a", "+/+", "+/-", "-/+", "-/-"]
    desc = ""
    case @arc.acttype
    when "New Cage"
      desc = "New cage ##{@arc.cage} created."
    when "Update Cage"
      desc = "Cage ##{@arc.cage} was updated: #{@arc.changed_attr} was changed from #{@arc.changed_attr.include?("genotype") ? (@arc.priorval == "0" ? "null" : gts[@arc.priorval.to_i]) : @arc.priorval} to #{@arc.changed_attr.include?("genotype") ? (@arc.newval == "0" ? "null" : gts[@arc.newval.to_i]) : @arc.newval}"
    when "Remove Cage"
      desc = "Cage ##{@arc.cage} was removed."
    when "New Pups"
      desc = "Cage ##{@arc.cage}: #{@arc.newval} were added"
    when "New Mouse ID"
      desc = "Cage ##{@arc.cage}: IDs #{@arc.newval} assigned to pups."
    when "Remove mouse"
      desc = "Mouse #{genMouseIDString(@arc.mouse.to_i)} was removed from Cage ##{@arc.cage}"
    when "Update Mouse"
      desc = "Mouse #{Mouse.find(@arc.mouse.to_i).designation} in Cage ##{@arc.cage} was updated: #{@arc.changed_attr} changed from #{@arc.priorval} to #{@arc.newval}"
    when "Biopsy Collection Date"
      desc = "Mouse #{Mouse.find(@arc.mouse.to_i).designation} in Cage ##{@arc.cage} biopsy collection date was set to #{@arc.newval}"
    when "Xfer Mouse"
      desc = "Mouse #{Mouse.find(@arc.mouse.to_i).designation} was transfered from Cage ##{@arc.priorval} to Cage ##{@arc.newval}"
    when "Reason for Mouse Removal"
      desc = "Mouse #{Mouse.find(@arc.mouse.to_i).designation} reason for removal: #{@arc.newval}"
    when "New Mouse"
      desc = "New mouse #{genMouseIDString(@arc.mouse.to_i)} was added to cage #{Mouse.find(@arc.mouse.to_i).cage.cage_number}"
    else
    end
    desc
  end

    def parseUser(id)
      @arc = Archive.find(id)
      @u = User.find(@arc.who)
      "#{@u.first} #{@u.last}"
    end

    def genMouseIDString(id)
      @m = Mouse.find(id)
      sex = (@m.sex.blank?) ? "|no sex|" : [nil,"F","M"][@m.sex.to_i]
      tdc = (@m.three_digit_code.blank?) ? "|no id|" : @m.three_digit_code
      ear = (@m.ear_punch.blank?) ? "|no ear punch|" : [nil,"-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"][@m.ear_punch.to_i]

      "#{sex}#{tdc}#{ear}"
    end
end

