class Mouse < ApplicationRecord
  belongs_to :cage
  has_paper_trail

  validates_uniqueness_of :designation, :scope => :strain,  :message => "not unique"
  validates_inclusion_of :ear_punch, :in => %w(N R L RL RR LL RLL RRL RRLL)
  validate :sex_matches_designation
  validate :ear_punch_matches_designation

  private

    def sex_matches_designation
      if sex != designation[0]
        errors.add(:designation, "First letter must match sex of the animal")
      end
    end

    def ear_punch_matches_designation 
      if designation.scan(/\d+|\D+/).last != ear_punch
        errors.add(:designation, "Last part of designation must match the ear_punch of the animal")
      end
    end

end
