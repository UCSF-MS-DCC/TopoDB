class Datapoint < ApplicationRecord
  belongs_to :mouse
  has_paper_trail
end
