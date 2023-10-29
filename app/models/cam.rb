class Cam < ApplicationRecord
  scope :favorites, -> { where(favorite: true) } 
end
