module TravelRequestsHelper
  def hf_funding_options
    FundingSource.active.group_by{|fs| fs.pi}.map{|k,v| [k, v.map{|a| a.display_name}]}
  end
end
