# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
strains = %w(ATXN1 Tau 2D2 ATXN1L CD79 CIC FLOX)
cage_types = %w(single-m single-f breeding experiment)
locations = %w(sandler genentech\ hall)

dgn = 100

if Mouse.count > 0
    Mouse.destroy_all
end
if Cage.count > 0
    Cage.destroy_all
end
if Archive.count > 0
    Archive.destroy_all
end

#create breeding cages
50.times do 

    ct = "breeding"
    st = strains[Faker::Number.between(from: 0, to: (strains.count - 1))]
    ln = locations[Faker::Number.between(from: 0, to: (locations.count - 1))]

    cage = Cage.new(cage_number:Faker::Number.between(from: 100000, to: 1500000), cage_type:ct, strain:st, location:ln, in_use:true)
    if cage.save
        
        ep1 = Faker::Number.within(range: 2..10)
        ep2 = Faker::Number.within(range: 2..10)
        types = %w(N R L RR RL LL RRL RLL RRLL)
        dbs = [Faker::Date.between(from: 1.year.ago, to: 6.months.ago), Faker::Date.between(from: 1.year.ago, to: 6.months.ago)]
        mouse1 = Mouse.new(:cage_id => cage.id, :sex => 2, :genotype => Faker::Number.within(range: 2..4), :dob => dbs[0] , :weaning_date => dbs[0] + 21, :three_digit_code => dgn,
                 :tail_cut_date => dbs[0] + 12, :ear_punch => ep1 , :designation => "M#{dgn}#{types[ep1 - 1]}", :tdc_generated => Time.now, :strain => cage.strain, :removed => nil ).save
        dgn += 1
        mouse2 = Mouse.new(:cage_id => cage.id, :sex => 1, :genotype => Faker::Number.within(range: 2..4), :dob => dbs[1] , :weaning_date => dbs[1] + 21, :three_digit_code => dgn,
                 :tail_cut_date => dbs[1] + 12, :ear_punch => ep2, :designation => "F#{dgn}#{types[ep2 - 1]}", :tdc_generated => Time.now, :strain => cage.strain, :removed => nil ).save
        dgn += 1
    end
end

24.times do

    ct = "breeding"
    st1 = strains[Faker::Number.between(from: 0, to: (strains.count - 1))]
    st2 = strains[Faker::Number.between(from: 0, to: (strains.count - 1))]
    ln = locations[Faker::Number.between(from: 0, to: (locations.count - 1))]

    cage = Cage.new(cage_number:Faker::Number.between(from: 100000, to: 150000), cage_type:ct, strain:st1, strain2:st2, location:ln, in_use:true)
    if cage.save
        
        ep1 = Faker::Number.within(range: 2..10)
        ep2 = Faker::Number.within(range: 2..10)
        types = %w(N R L RR RL LL RRL RLL RRLL)
        dbs = [Faker::Date.between(from: 1.year.ago, to: 6.months.ago), Faker::Date.between(from: 1.year.ago, to: 6.months.ago)]
        mouse1 = Mouse.new(:cage_id => cage.id, :sex => 2, :genotype => Faker::Number.within(range: 2..4), :genotype2 => Faker::Number.within(range: 2..4), :dob => dbs[0] , :weaning_date => dbs[0] + 21, :three_digit_code => dgn,
                 :tail_cut_date => dbs[0] + 12, :ear_punch => ep1 , :designation => "M#{dgn}#{types[ep1 - 1]}", :tdc_generated => Time.now, :strain => st1, :strain2 => st2, :removed => nil ).save
        dgn += 1
        mouse2 = Mouse.new(:cage_id => cage.id, :sex => 1, :genotype => Faker::Number.within(range: 2..4), :genotype2 => Faker::Number.within(range: 2..4), :dob => dbs[1] , :weaning_date => dbs[1] + 21, :three_digit_code => dgn,
                 :tail_cut_date => dbs[1] + 12, :ear_punch => ep2, :designation => "F#{dgn}#{types[ep2 - 1]}", :tdc_generated => Time.now, :strain => st1, :strain2 => st2, :removed => nil ).save
        dgn += 1
    end
end
# create single-sex cages
dgn = 200

50.times do
    sx = Faker::Number.between(from:1, to:10) < 6 ? 'f' : 'm' 
    ct = "single-#{sx}"
    st = strains[Faker::Number.between(from: 0, to: (strains.count - 1))]
    ln = locations[Faker::Number.between(from: 0, to: (locations.count - 1))]

    cage = Cage.new(cage_number:Faker::Number.between(from: 200000, to: 250000), cage_type:ct, strain:st, location:ln, in_use:true)
    if cage.save
        types = %w(N R L RR RL LL RRL RLL RRLL)

        Faker::Number.between(from:6, to:12).times do 
            db = Faker::Date.between(from:2.years.ago, to:3.months.ago)
            ep1 = Faker::Number.within(range: 2..10)
            Mouse.new(:cage_id => cage.id, :sex => sx == "f" ? 1 : 2, :genotype => Faker::Number.within(range: 2..4), :dob => db , :weaning_date => db + 21, :three_digit_code => dgn,
                    :tail_cut_date => db + 12, :ear_punch => ep1 , :designation => "#{sx.upcase}#{dgn}#{types[ep1 - 1]}", :tdc_generated => Time.now, :strain => cage.strain, :removed => nil ).save
            dgn += 1
        end 
    end
end
# create experiment cages
50.times do
    sx = Faker::Number.between(from:1, to:10) < 6 ? 'f' : 'm' 
    ct = "experiment"
    st = strains[Faker::Number.between(from: 0, to: (strains.count - 1))]
    ln = locations[Faker::Number.between(from: 0, to: (locations.count - 1))]
    gt = Faker::Number.between(from:2, to: 4)

    cage = Cage.new(cage_number:Faker::Number.between(from: 300000, to: 350000), cage_type:ct, strain:st, location:ln, in_use:true, genotype:gt)
    if cage.save
        types = %w(N R L RR RL LL RRL RLL RRLL)

        Faker::Number.between(from:6, to:12).times do 
            ep1 = Faker::Number.within(range: 2..10)
            mths = Faker::Number.between(from:2, to:24)
            db = Faker::Date.between(from:mths.months.ago, to:(mths - 1).months.ago)
            Mouse.new(:cage_id => cage.id, :sex => sx == "f" ? 1 : 2, :genotype => gt, :dob => db , :weaning_date => db + 21, :three_digit_code => dgn,
                    :tail_cut_date => db + 12, :ear_punch => ep1 , :designation => "#{sx.upcase}#{dgn}#{types[ep1 - 1]}", :tdc_generated => Time.now, :strain => cage.strain, :removed => nil ).save
            dgn += 1
        end 
    end
end