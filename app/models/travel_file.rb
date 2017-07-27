class TravelFile < ActiveRecord::Base
  has_paper_trail

  belongs_to :filable, polymorphic: true
  belongs_to :user_file, dependent: :destroy, inverse_of: :travel_files
  accepts_nested_attributes_for :user_file, allow_destroy: true
end
