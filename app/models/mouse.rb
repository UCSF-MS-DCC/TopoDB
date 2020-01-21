class Mouse < ApplicationRecord
  belongs_to :cage
  has_paper_trail

  # validates_uniqueness_of :designation, :scope => [:strain],  :message => "not unique"
  # validates_inclusion_of :ear_punch, :in => %w(N R L RL RR LL RLL RRL RRLL), :if => :has_ear_punch?
  # validate :sex_matches_designation
  # validate :ear_punch_matches_designation
  # validate :designation_is_available, on: :create
  validates_uniqueness_of :three_digit_code, :scope => [:strain, :strain2, :removed], on: :update, allow_nil: true, allow_blank: true
  # validates_uniqueness_of :ear_punch, :scope => [:cage_id, :dob, :sex], on: :update, allow_nil: true, allow_blank: true
  
  def assign_full_designation
    # find the most recent id of a living mouse in the same strain/hybrid strain
    current_max_id = Mouse.where(strain:self.strain).where(strain2:self.strain2).(removed:nil).order(:tdc_generated).last.three_digit_code
    puts "CURRENT MAX ID: #{current_max_id}"
  end

  private

    def three_digit_code_is_valid
      tdc_array = three_digit_code.scan(/\d+|\D+/)

    end

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
