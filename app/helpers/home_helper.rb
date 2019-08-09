module HomeHelper

    def log_mouse_cage_transfer(mouse, source_cage, target_cage, user)
        @archive = Archive.new(objdsn:mouse.designation, objtype:"Mouse", acttype:"Xfer Mouse", priorval:Cage.find(source_cage).cage_number, newval:Cage.find(target_cage).cage_number, who:user.id)
        if @archive.save
            puts "Archive created"
        else
            puts @archive.errors.full_messages
        end
    end

    def log_new_cage(cage, user)
        @archive = Archive.new(objdsn:cage.cage_number, objtype:"Cage", acttype:"New Cage", newval:cage.strain, who:user.id)
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
end
