class Mouse < ApplicationRecord
  belongs_to :cage

  validates_uniqueness_of :designation, :scope => :strain,  :message => "not unique"
  validates
end
