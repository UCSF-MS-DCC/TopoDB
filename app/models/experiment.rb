class Experiment < ApplicationRecord
    has_many :mice
    serialize :variables, Array
    has_paper_trail
    
    def update_last_viewed
        self.update_columns(last_viewed: Time.now)
    end





end
