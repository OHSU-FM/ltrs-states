class FundingSource < ApplicationRecord
  validates :title, :pi, presence: true
  validate :dates

  scope :active, -> { where("? BETWEEN start_date AND end_date", Date.today) }

  # :nocov:
  rails_admin do
    edit do
      field :pi do
        label "PI"
      end

      include_all_fields
    end
  end
  # :nocov:

  def display_name
    title
  end

  private

  def dates
    if start_date.nil?
      errors.add(:start_date, "Start Date can't be blank")
      return
    end
    if end_date.nil?
      errors.add(:end_date, "End Date can't be blank")
      return
    end
    if end_date < start_date
      errors.add(:end_date, 'End Date must be after Start Date')
    end
  end
end
