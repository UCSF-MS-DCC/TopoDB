class Cage < ApplicationRecord
    has_many :mice
    has_paper_trail

    validates_presence_of :cage_type
    validates_inclusion_of :cage_type, :in => ["single-m", "single-f", "breeding", "experiment"]
    validates_presence_of :location
    validates_presence_of :cage_number
    validates_numericality_of :cage_number
    validates_presence_of :strain
    validates_uniqueness_of :cage_number, scope: [:strain, :strain2, :location] 
    before_update :recode_genotypes
    after_update :remove_mice, if: :not_in_use?
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

    def recode_genotypes
        genotypes = [nil, "n/a", "+/+", "+/-", "-/-"]
        if self.genotype && self.genotype.blank? 
            self.genotype = 0
        elsif self.genotype && (!self.genotype.is_a? Integer)
            self.genotype = genotypes.index(self.genotype)
        end
        if self.genotype2 && self.genotype2.blank? 
            self.genotype2 = 0
        elsif self.genotype2 && (!self.genotype.is_a? Integer)
            self.genotype2 = genotypes.index(self.genotype2)
        end
    end 

    def not_in_use?
        self.in_use == false
    end

    def remove_mice
        self.mice.each do |mouse|
            mouse.update_attributes(removed:Date.today.strftime("%Y-%m-%d"))
        end
    end

    def update_last_viewed
        self.update_columns(last_viewed: Time.now)
    end

    private
    def set_default_values
        self.in_use = true
    end

end
