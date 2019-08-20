class Cage < ApplicationRecord
    has_many :mice
    has_paper_trail

    validates_presence_of :cage_type
    validates_inclusion_of :cage_type, :in => ["single-m", "single-f", "breeding"]
    validates_presence_of :location
    validates_inclusion_of :location, :in => ["sandler", "genentech hall"]
    validates_presence_of :cage_number
    validates_numericality_of :cage_number
    validates_presence_of :strain
    validates_uniqueness_of :cage_number

    # before_create :set_default_values
    # validates :pups, absence: true, if: :is_single_sex?

    def is_single_sex?
        self.cage_type.include?('single')
    end
    def female_pups
        self.mice.where(sex:"F").where(weaning_date:nil).count
    end
    def male_pups
        self.mice.where(sex:"M").where(weaning_date:nil).count
    end

    private
    def set_default_values
        self.in_use = true
    end

end
