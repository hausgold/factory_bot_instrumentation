# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  # Mark this class to be not a real record
  self.abstract_class = true
end
