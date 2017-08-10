module MealReimbursementRequestsHelper
  def hf_reimb_tf_to_words meal
    meal == true ? 'Per Diem' : 'NA'
  end
end
