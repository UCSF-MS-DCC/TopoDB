module HomeHelper

    def log_mouse_cage_transfer(mouse, source_cage, target_cage, user)
        @archive = Archive.new(mouse:mouse.id, acttype:"Xfer Mouse", priorval:Cage.find(source_cage).cage_number, newval:Cage.find(target_cage).cage_number, who:user.id)
        if @archive.save
            puts "Archive created"
        else
            puts @archive.errors.full_messages
        end
    end

    def log_new_cage(cage, user)
        @archive = Archive.new(cage:cage.cage_number, acttype:"New Cage", who:user.id)
        if @archive.save
            puts "Archive created"
        else
            puts @archive.errors.full_messages
        end
    end

    def log_new_pups(cage, number, sex, user)
        @archive = Archive.new(objdsn:cage, objtype:"Cage", acttype:"New Pups", newval:"#{number} #{sex}", who:user.id)
        if @archive.save
            puts "Archive created"
        else
            puts @archive.errors.full_messages
        end
    end

    def log_update_cage(cage, updateCageParams, user)
        updateCageParams.each do |k, v|
            puts cage
            if k.to_s == "in_use"
                @archive = Archive.new(cage:cage, acttype:"Remove Cage", who:user.id)
            else
                @archive = Archive.new(cage:cage, acttype:"Update Cage", changed_attr:k.to_s, priorval:updateCageParams[k][:priorval], newval:updateCageParams[k][:newval], who:user.id)
            end
            if @archive.save
                puts "Archive created"
            else
                puts @archive.errors.full_messages
            end
        end
    end

    def log_new_ids(mouse, user)
        @archive = Archive.new(objdsn:mouse.cage.cage_number, objtype:"Mouse", acttype:"New Mouse ID", objattr:"designation", newval:mouse.designation, who:user.id)
        if @archive.save
            puts "Archive created"
        else
            puts @archive.errors.full_messages
        end
    end

    def log_update_mouse(mouse, updateParams, user)
        # for genotypes, ear punches,and sexes subtract 1 from the number passed as a parameter value to get the corresponding array index 
        gt = ["n/a", "+/+" , "+/-", "-/+" ,"-/-"]
        ep = ["-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"]
        sx = ["F", "M"]
        puts updateParams
        @archive = nil
        if updateParams[:updateattr] == "genotype"
            @archive = Archive.new(mouse:mouse.id, cage:mouse.cage.cage_number, acttype:"Update Mouse", changed_attr:"genotype", priorval:updateParams[:values][:priorval].to_i >= 0 ? gt[(updateParams[:values][:priorval].to_i - 1)] : "null", newval:gt[(updateParams[:values][:newval].to_i - 1)], who:user.id)
        elsif updateParams[:updateattr] == "genotype2"
            @archive = Archive.new(mouse:mouse.id, cage:mouse.cage.cage_number, acttype:"Update Mouse", changed_attr:"genotype2", priorval:updateParams[:values][:priorval].to_i >= 0 ? gt[(updateParams[:values][:priorval].to_i - 1)] : "null", newval:gt[(updateParams[:values][:newval].to_i - 1)], who:user.id)
        elsif updateParams[:updateattr] == "ear_punch"
            @archive = Archive.new(mouse:mouse.id, cage:mouse.cage.cage_number, acttype:"Update Mouse", changed_attr:"ear punch", priorval:updateParams[:values][:priorval].to_i >= 0 ? ep[(updateParams[:values][:priorval].to_i - 1)] : "null", newval:ep[(updateParams[:values][:newval].to_i - 1)], who:user.id)
        elsif updateParams[:updateattr] == "sex"
            @archive = Archive.new(mouse:mouse.id, cage:mouse.cage.cage_number, acttype:"Update Mouse", changed_attr:"sex", priorval:updateParams[:values][:priorval].to_i >= 0 ? sx[(updateParams[:values][:priorval].to_i  - 1)] : "null", newval:sx[(updateParams[:values][:newval].to_i - 1)], who:user.id)
        elsif updateParams[:updateattr] == "designation"
            @archive = Archive.new(mouse:mouse.id, cage:mouse.cage.cage_number, acttype:"Update Mouse", changed_attr:"mouse id", priorval:updateParams[:values][:priorval], newval:updateParams[:values][:newval], who:user.id)
        elsif updateParams[:updateattr] == "tail_cut_date"
            @archive = Archive.new(mouse:mouse.id, cage:mouse.cage.cage_number, acttype:"Tail Cut Date", changed_attr:"tail cut date", priorval:updateParams[:values][:priorval] != "-1" ? updateParams[:values][:priorval] : "null", newval:updateParams[:values][:newval], who:user.id)
        elsif updateParams[:updateattr] == "removed_for"
            @archive = Archive.new(mouse:mouse.id, cage:mouse.cage.cage_number, acttype:"Reason for Mouse Removal", changed_attr:"removed for reason", priorval:updateParams[:values][:priorval], newval:updateParams[:values][:newval], who:user.id)
        else
        end
        if @archive && @archive.save
            puts "Archive created"
        else
            puts @archive.errors.full_messages
        end
    end

    def log_remove_mouse(cage, mouse, user)
        @archive = Archive.new(cage:cage, mouse:mouse, acttype:"Remove mouse", who:user.id)
        if @archive.save
            puts "Mouse deleted"
        else
            puts @archive.errors.full_messages
        end
    end
    def validate_date(input)
        /\d{4}\-\d{2}-\d{2}/.match(input) || input == nil
    end
end

