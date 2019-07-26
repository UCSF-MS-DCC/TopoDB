require 'test_helper'

class CageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'valid cage' do
    testcage = Cage.new(cage_number:"56565", cage_type:"single", location:"sandler", rack:"L5", cage_number_changed:false)
    assert testcage.valid?
  end

  test 'validates cage type inclusion in enumerated group' do
    testcage = Cage.new(cage_number:"56565", cage_type:"experiment", location:"sandler", rack:"L5", cage_number_changed:false)
    assert testcage.invalid?
  end

  test 'validates cage location inclusion in enumerated group' do
    testcage = Cage.new(cage_number:"56565", cage_type:"breeding", location:"mission hall", rack:"L5", cage_number_changed:false)
    assert testcage.invalid?
  end

  test 'validates that cage_numbers are unique' do
    cage1 = Cage.new(cage_number:"12345", cage_type:"breeding", location:"sandler", rack:"L5", cage_number_changed:false)
    assert cage1.invalid?
  end

  test 'validates single sex cages do not have pups' do
    cage1 = Cage.new(cage_number:"56565", cage_type:"single", location:"sandler", rack:"L5", cage_number_changed:false, pups: 5)
    assert cage1.invalid?
  end

end
