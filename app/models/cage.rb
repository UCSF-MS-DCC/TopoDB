class Cage < ApplicationRecord
    has_many :mice

    validates_inclusion_of :cage_type, :in => ["single", "breeding"]
    validates_inclusion_of :location, :in => ["sandler", "genentech hall"]
    validates_uniqueness_of :cage_number
    validates :pups, absence: true, if: :is_single_sex?
    
    def is_single_sex?
        self.cage_type == "single"
    end
end
