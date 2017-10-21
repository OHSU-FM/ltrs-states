module GrantFundedTravelRequestsHelper
  def hf_business_purpose_desc_to_human
    {
     'site_visit' => 'Site Visit',
     'conference' => 'Conference',
     'in_person_interview' => 'In Person Interview',
     'other' => 'Other'
    }
  end

  def hf_ff_number_enum ffns
    return [] if ffns.nil?
    ffns.map {|ffn| [ffn.airline, ffn.ffid] }
  end
end
