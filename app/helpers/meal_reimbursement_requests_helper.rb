module MealReimbursementRequestsHelper
  def hf_meal_reimb_tf_to_words meal
    meal == true ? 'Per Diem' : 'NA'
  end

  def hf_reimb_tf_to_words bool
    bool == true ? 'Yes' : 'No'
  end
end
