class Mouse < ApplicationRecord
  belongs_to :cage
  has_paper_trail

  # validates_uniqueness_of :designation, :scope => [:strain],  :message => "not unique"
  # validates_inclusion_of :ear_punch, :in => %w(N R L RL RR LL RLL RRL RRLL), :if => :has_ear_punch?
  # validate :sex_matches_designation
  # validate :ear_punch_matches_designation
  # validate :designation_is_available, on: :create
  # validate :three_digit_code_is_unique, on: :create
  
  def assign_full_designation
    if self.sex != nil && self.ear_punch != nil
      sx = %w(F M)
      ep = %w(- N R L RR RL LL RRL RLL RRLL)
      new_index = nil
      # if a pup is a from a new strain, then there will be no previous three_digit_code to increment. In this case, set it to "001", in all other cases take the next available three_digit_code number
      if Mouse.where(strain:self.strain).where(strain2:self.strain2).where(removed:nil).count == 0
        new_index = "001"
      else     
        # find the highest three_digit_code among living mice within the current strain/hybrid strain
        current_max_tdc = Mouse.where(strain:self.strain).where(strain2:self.strain2).where(removed:nil).where.not(three_digit_code:nil).order("created_at").pluck(:three_digit_code).map(&:to_i).last
        #puts Mouse.where(strain:self.strain).where(strain2:self.strain2).where(removed:nil).where.not(three_digit_code:nil).order("created_at").pluck(:three_digit_code).map(&:to_i)
        # initialize a variable to hold the value of the next available integer
        next_tdc = nil
        # tdc is only three characters and "000" is not used. So after "999", the tdcs must rollover, and start looking for the first unused value starting with 1
        if current_max_tdc == 999 # this if/else should only be concerned with finding the next valid three_digit_code.
          # get ordered list of three_digit_codes as integers (TDCIs), then iterate starting at one until finding a value NOT in the list, then create a three character string (inserting leading zeroes as necessary)
          tdcis = Mouse.where(strain:self.strain).where(strain2:self.strain2).where(removed:nil).where.not(three_digit_code:nil).pluck(:three_digit_code).map(&:to_i).sort
          idx = 1
          while next_tdc == nil
            if tdcis.exclude?(idx)
              next_tdc = idx
            end
            idx += 1
          end
        else
          # if the current_max_tdc is below "999", create the next_tdc by converting the current_max_tdc to an integer, incrementing it, then creating a three character string (inserting leading zeroes as necessary)
          next_tdc = current_max_tdc + 1
          #puts "New max tdc is #{next_tdc}"
        end
        # turn the next_tdc into a string, inserting leading zeroes as necessary
        if next_tdc < 10
          new_index = "00#{next_tdc.to_s}"
        elsif next_tdc < 100
          new_index = "0#{next_tdc.to_s}"
        else
          new_index = next_tdc.to_s
        end
      end
      self.designation = "#{sx[(self.sex.to_i - 1)]}#{new_index}#{ep[(self.ear_punch.to_i - 1)]}"
      self.three_digit_code = new_index
    else
      errors.add(:designation, "Mouse must have sex and ear punch defined before assigning a full ID")
    end
  end

  private


    def has_ear_punch?
      ear_punch != nil
    end
    def sex_matches_designation
      if designation != nil && sex != designation[0]
        errors.add(:designation, "First letter must match sex of the animal")
      end
    end

    def ear_punch_matches_designation 
      if designation != nil && designation.scan(/\d+|\D+/).last != ear_punch
        errors.add(:designation, "Last part of designation must match the ear_punch of the animal")
      end
    end

    def designation_is_available
      if designation != nil && Mouse.where(designation:designation).where(euthanized:false).where(strain:strain).count > 0
        errors.add(:designation, "Another living mouse in this strain has this designation")
      end
    end

    def increment_animal_index(array, idx)
      if idx < 0 
        array
      elsif array[idx].to_i == 9
        array[idx] = "0"
        increment_animal_index(array, idx - 1)
      else
        array[idx] = (array[idx].to_i + 1).to_s
        array
      end
    end

end
