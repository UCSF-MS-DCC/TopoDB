class Experiment < ApplicationRecord
    has_many :mice
    serialize :variables, Array
    has_paper_trail
    before_create :delete_empty_variables

    def delete_empty_variables
        vars_list = []
        self.variables.each do |v|
            unless v.blank?
                vars_list.push(v)
            end
        end
        self.variables = vars_list
    end
    def update_last_viewed
        self.update_columns(last_viewed: Time.now)
    end





end
