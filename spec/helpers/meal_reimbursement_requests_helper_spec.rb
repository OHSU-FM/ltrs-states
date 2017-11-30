require 'rails_helper'

RSpec.describe MealReimbursementRequestsHelper, type: :helper do
  describe '#hf_meal_reimb_tf_to_words' do
    it "returns 'Per Diem' if true" do
      expect(helper.hf_meal_reimb_tf_to_words(true)).to eq 'Per Diem'
      expect(helper.hf_meal_reimb_tf_to_words(false)).to eq 'NA'
    end
  end

  describe '#hf_reimb_tf_to_words' do
    it "returns 'Yes' if true" do
      expect(helper.hf_reimb_tf_to_words(true)).to eq 'Yes'
      expect(helper.hf_reimb_tf_to_words(false)).to eq 'No'
    end

    it "returns 'Unanswered' if nil" do
      expect(helper.hf_reimb_tf_to_words(nil)).to eq 'Unanswered'
    end
  end
end
