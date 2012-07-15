require "spec_helper"

describe PlanCategoriesController do
  it_behaves_like "an admin controller", :plan_category do
    let(:event) { FactoryGirl.create :event }
    let(:extra_params_for_create) { {:plan_category => {:event_id => event.id}} }
    let(:updateable_attribute) { :description }
  end

  let(:cat) { FactoryGirl.create :plan_category }
  let!(:plan) { FactoryGirl.create :plan, disabled: true, plan_category: cat }

  describe "#destroy" do
    context "when the Plan Category is in use" do
      before(:each) do
        plan.attendees << FactoryGirl.build(:attendee)
      end
      it "admin should get a friendly warning" do
        sign_in FactoryGirl.create(:admin)
        expect { delete :destroy, id: cat.id, year: cat.year
          }.to_not change{ PlanCategory.count }
        flash[:alert].should include "Cannot delete the '#{cat.name}' category"
      end
    end
  end

  describe "GET show" do
    it "user cannot see disabled plans" do
      user = FactoryGirl.create :user
      sign_in user
      get :show, year: cat.year, id: cat.id
      assigns(:plans).map(&:id).should_not include(plan.id)
    end

    it "admin can see disabled plans" do
      admin = FactoryGirl.create :admin
      sign_in admin
      get :show, year: cat.year, id: cat.id
      assigns(:plans).map(&:id).should include(plan.id)
    end
  end
end
