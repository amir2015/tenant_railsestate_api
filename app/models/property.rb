class Property < ApplicationRecord
  belongs_to :company
  belongs_to :agent
end
