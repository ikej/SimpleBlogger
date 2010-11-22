module SearchHelper
  def highlight_criteria_in_search_result(criteria, result)
    start_match_index = result.downcase.strip =~ /#{criteria.downcase.strip}/
    pre_match = result[0,start_match_index]
    post_match = result[start_match_index + criteria.length,result.length-start_match_index-criteria.length] 
    if start_match_index
      [pre_match, "<span style='background-color: #FFFF00'><b>#{criteria}</b></span>", post_match]
    else
      [result,'','']
    end
  end
end
