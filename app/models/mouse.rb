class Mouse < ApplicationRecord
  belongs_to :cage
  has_paper_trail

  # validates_uniqueness_of :designation, :scope => [:strain],  :message => "not unique"
  # validates_inclusion_of :ear_punch, :in => %w(N R L RL RR LL RLL RRL RRLL), :if => :has_ear_punch?
  # validate :sex_matches_designation
  # validate :ear_punch_matches_designation
  # validate :designation_is_available, on: :create

  scope :is_alive?, -> { where(euthanized:false) }

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

end
