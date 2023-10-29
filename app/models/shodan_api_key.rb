class ShodanApiKey < ApplicationRecord
  validates :key, length: { is: 32 }, uniqueness: { message: 'already in database' }
end
