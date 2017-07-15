class TravelFile < ActiveRecord::Base
  has_paper_trail

  belongs_to :travel_request, inverse_of: :travel_files
  belongs_to :user_file, dependent: :destroy, inverse_of: :travel_files
  accepts_nested_attributes_for :user_file, allow_destroy: true
end
