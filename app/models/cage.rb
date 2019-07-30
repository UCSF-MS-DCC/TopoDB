class Cage < ApplicationRecord
    has_many :mice
    has_paper_trail

    validates_inclusion_of :cage_type, :in => ["single", "breeding"]
    validates_inclusion_of :location, :in => ["sandler", "genentech hall"]
    validates_presence_of :cage_number
    validates_presence_of :strain
    validates_uniqueness_of :cage_number
    validates :pups, absence: true, if: :is_single_sex?
    
    def is_single_sex?
        self.cage_type == "single"
    end
end
