require 'test_helper'

class CageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'valid cage' do
    testcage = Cage.new(cage_number:"56565", cage_type:"single-m", location:"sandler", rack:"L5", cage_number_changed:false, strain:"Tau")
    assert testcage.valid?
    puts testcage.errors.full_messages
  end

  test 'validates cage type inclusion in enumerated group' do
    testcage = Cage.new(cage_number:"56565", cage_type:"experiment", location:"sandler", rack:"L5", cage_number_changed:false, strain:"Tau")
    assert testcage.invalid?
  end

  test 'validates cage location inclusion in enumerated group' do
    testcage = Cage.new(cage_number:"56565", cage_type:"breeding", location:"mission hall", rack:"L5", cage_number_changed:false, strain:"Tau")
    assert testcage.invalid?
  end

  test 'validates that cage_numbers are unique' do
    cage1 = Cage.new(cage_number:"12345", cage_type:"breeding", location:"sandler", rack:"L5", cage_number_changed:false, strain:"Tau")
    assert cage1.invalid?
  end

  test 'validates single sex cages do not have pups' do
    cage1 = Cage.new(cage_number:"56565", cage_type:"single-m", location:"sandler", rack:"L5", cage_number_changed:false, pups: 5, strain:"Tau")
    assert cage1.invalid?
  end

end
