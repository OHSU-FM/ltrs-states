require 'rails_helper'

RSpec.describe Concerns::StateEventsHelper, type: :helper do

  describe 'hf_transition_to_in_review?' do
    context 'when user has single reviewer' do
      context 'and record is unopened' do
        let(:lr) { create :leave_request, :unopened }

        it 'returns true if the current_user is current reviewer' do
          r = lr.user.reviewers.first.approver
          expect(helper.hf_transition_to_in_review?(lr, r)).to be true
        end

        it 'returns false if the current_user is the user' do
          u = lr.user
          expect(helper.hf_transition_to_in_review?(lr, u)).to be false
        end

        it 'returns false if the current_user is an admin' do
          a = create :admin
          expect(helper.hf_transition_to_in_review?(lr, a)).to be false
        end
      end

      context 'when record is not unopened' do
        let(:lr) { create :leave_request, :in_review }

        it 'returns false' do
          r = lr.user.reviewers.first.approver
          expect(helper.hf_transition_to_in_review?(lr, r)).to be false
        end
      end
    end

    context 'when user has two reviewers' do
      context 'and record is unopened' do
        context 'the first time through' do
          let(:lr) { create :leave_request, :unopened, :two_reviewers }

          it 'returns true if the current_user is the current reviewer' do
            r = lr.user.reviewers.first.approver
            expect(helper.hf_transition_to_in_review?(lr, r)).to be true
          end

          it 'returns false if the current_user is the next reviewer' do
            r = lr.user.reviewers.last.approver
            expect(helper.hf_transition_to_in_review?(lr, r)).to be false
          end

          it 'returns false if the current_user is the user' do
            u = lr.user
            expect(helper.hf_transition_to_in_review?(lr, u)).to be false
          end

          it 'returns false if the current_user is an admin' do
            a = create :admin
            expect(helper.hf_transition_to_in_review?(lr, a)).to be false
          end
        end

        context 'the second time through' do
          let(:lr) { create :leave_request, :back_to_unopened, :two_reviewers }

          it 'returns true if the current_user is the current reviewer' do
            r = lr.user.reviewers.last.approver
            expect(helper.hf_transition_to_in_review?(lr, r)).to be true
          end

          it 'returns false if the current_user is the next reviewer' do
            r = lr.user.reviewers.first.approver
            expect(helper.hf_transition_to_in_review?(lr, r)).to be false
          end

          it 'returns false if the current_user is the user' do
            u = lr.user
            expect(helper.hf_transition_to_in_review?(lr, u)).to be false
          end

          it 'returns false if the current_user is an admin' do
            a = create :admin
            expect(helper.hf_transition_to_in_review?(lr, a)).to be false
          end
        end
      end

      context 'and record is not unopened' do
        let(:lr) { create :leave_request, :in_review, :two_reviewers }

        it 'returns false' do
          r = lr.user.reviewers.first.approver
          expect(helper.hf_transition_to_in_review?(lr, r)).to be false
        end
      end
    end
  end
end
