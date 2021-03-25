class Subject < ApplicationRecord
  has_many :questions
  paginates_per 2

end
