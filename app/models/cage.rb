class Cage < ApplicationRecord
    has_many :mice
    has_paper_trail
    has_many_attached :attachments

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

    def get_csv
        sex = ["-","F","M"]
        punch = ["","-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"]
        geno = ["","n/a","+/+","+/-","-/-"]
        CSV.generate do |csv|
            col_heads = Mouse.column_names.reject{ |cn| ["id", "cage_id", "tdc_generated", "updated_at", "created_at", "experiment_code", "strain2", "experiment_id", "designation"].include? cn }.map{ |cn| cn.to_s }
            mice = self.mice
            csv << col_heads
            mice.each do |m|
                row = m.attributes.values_at(*col_heads)
                row[0] = sex[row[0].to_i]
                row[1] = geno[row[1].to_i]
                row[5] = punch[row[5].to_i]
                unless row[11].blank?
                    row[11] = geno[row[12].to_i]
                end
                csv << row
            end
        end
    end

    private
    def set_default_values
        self.in_use = true
    end

end
