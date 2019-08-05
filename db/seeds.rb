# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
strains = %w(ATXN1 Tau 2D2 ATXN1L CD79 CIC\ FLOX)
cage_types = %w(single-m single-f breeding)
locations = %w(sandler genentech\ hall)

# strains.each do |strain|
#     num_cages = Faker::Number.between(5,8)
#     num_cages.times do
#         loc = locations[Faker::Number.between(0,1)]
#         ct = cage_types[Faker::Number.between(0,2)]
#         rk = ["R1", "R2", "R3", "L1", "L2", "L3"][Faker::Number.between(0,5)]
#         cnc = false
#         pps = ct == "breeding" ? Faker::Number.between(1,5) : nil 
#         sx = ct == "breeding" ?  nil : ["F", "M"][Faker::Number.between(0,1)]
#         cn = Faker::Number.between(100000, 200000)
#         cage = Cage.new(:strain => strain, :cage_number => cn, :cage_type => ct, :location => loc, :cage_number_changed => cnc, :pups => pps, :sex => sx, :rack => rk)

#         if cage.save 
#             puts "Cage saved"
#         else
#             puts cage.errors.full_messages
#         end
#     end
# end

dgn = 500

Cage.all.each do |c|
    ct = c.cage_type  
    db = Faker::Date.between(1.year.ago, 3.months.ago)

    if ct == "breeding"
        pop = Faker::Number.between(2, 3)
        puts "#{ct} cage, generating #{pop} mice"
        pop.times do |num|
            bd = Faker::Date.between(1.year.ago, 3.months.ago)
            wd = bd + 21
            ep = ["N", "L", "LL", "R", "RR", "RRL", "RLL", "RRLL"][Faker::Number.between(0,7)]
            gt = ["+/+", "-/-", "+/-", "-/+"][Faker::Number.between(0,3)]
            if num == 0
                mouse = Mouse.new(:cage_id => c.id, :sex => "M", :genotype => gt, :dob => bd, :weaning_date => wd, :tail_cut_date => bd + 7, :ear_punch => ep, :designation => "M#{dgn}#{ep}", :strain => c.strain )
                mouse.save
                dgn += 1
            else
                mouse = Mouse.new(:cage_id => c.id, :sex => "F", :genotype => gt, :dob => bd, :weaning_date => wd, :tail_cut_date => bd + 7, :ear_punch => ep, :designation => "F#{dgn}#{ep}", :strain => c.strain )
                mouse.save
                dgn += 1
            end
        end

    else
        pop = Faker::Number.between(3, 5)
        puts "#{ct} cage, generating #{pop} mice"
        pop.times do
            bd = Faker::Date.between(1.year.ago, 3.months.ago)
            wd = bd + 21
            ep = ["N", "L", "LL", "R", "RR", "RRL", "RLL", "RRLL"][Faker::Number.between(0,7)]
            gt = ["+/+", "-/-", "+/-", "-/+"][Faker::Number.between(0,3)]
            sx = c.sex
            mouse = Mouse.new(:cage_id => c.id, :sex => sx, :genotype => gt, :dob => bd, :weaning_date => wd, :tail_cut_date => bd + 7, :ear_punch => ep, :designation => "#{sx}#{dgn}#{ep}", :strain => c.strain, :parent_cage_id => Faker::Number.between(100000, 200000) )
            mouse.save
            dgn += 1
        end
    end
end
