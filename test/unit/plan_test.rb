require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  test "#inventory_consumed" do
    p = Factory :plan, max_quantity: 3
    a = Factory :attendee
    p.attendee_plans.create! quantity: 3, year: p.year, attendee_id: a.id
    assert_equal 3, p.inventory_consumed
  end

  test "factory is valid" do
    assert Factory.build(:plan).valid?
  end

  test "an inventory of zero is invalid" do
    assert !Factory.build(:plan, inventory: 0).valid?
  end

  test "max qty" do
    p = Factory.build(:plan, :max_quantity => 1)
    assert p.valid?
    p.max_quantity = 0
    assert !p.valid?
    p.max_quantity = -1
    assert !p.valid?
  end
end
