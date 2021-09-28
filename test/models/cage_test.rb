require 'test_helper'

class CageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    # @breed_cage = cages(:breeding_cage)
    # @single_sex_cage = cages(:single_sex_cage)
  end

  test 'cage has a valid cage type from the enumerated list' do
    @cage1 = Cage.new(cage_number:"12345", cage_type:"none", strain:"ATXN1", location:"Building 1")
    assert @cage1.invalid?
    @cage2 = Cage.new(cage_number:"12345", cage_type:nil, strain:"ATXN1", location:"Building 1")
    assert @cage2.invalid?
    @cage3 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", location:"Building 1")
    assert @cage3.valid?
  end

  test 'presence of location, cage_number, and strain' do
    @cage1 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", location:nil)
    assert @cage1.invalid?
    @cage2 = Cage.new(cage_number:nil, cage_type:"breeding", strain:"ATXN1", location:"Building 1")
    assert @cage2.invalid?
    @cage3 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:nil, location:"Building 1")
    assert @cage3.invalid?
    @cage3 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", location:"Building 1")
    assert @cage3.valid?
  end

  test 'cage number is unique within scope of strain, strain2, and location' do
    @cage1a = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", location:"Building 1").save
    @cage1b = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", strain2:"CIC", location:"Building 1").save
    # same cage number, location, and strain/strain2 - should be invalid
    @cage2a = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", strain2:"CIC", location:"Building 1")
    assert @cage2a.invalid?
    @cage2b = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", location:"Building 1")
    assert @cage2b.invalid?
    # same cage number & location, different strain - should be valid
    @cage3 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"Tau", location:"Building 1")
    assert @cage3.valid?
    # same cage number, strain, location, different strain2 - should be valid
    @cage4 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", strain2:"Tau", location:"Building 1")
    assert @cage4.valid?
    # same cage number & strain, different location - should be valid
    @cage5 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", location:"Building 11")
    assert @cage5.valid?
  end

  test 'database defaults are used when in cage creation when not supplied, and supplied values are used when they are supplied' do 
    @cage1 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", location:"Building 1")
    @cage1.save
    assert @cage1[:genotype] == "0"
    assert @cage1[:genotype2] == "0"
    assert @cage1[:in_use] == true

    @cage2 = Cage.new(cage_number:"12345", cage_type:"breeding", strain:"ATXN1", location:"Building 1", genotype:"2", genotype2:"1")
    @cage2.save
    assert @cage2[:genotype] == "2"
    assert @cage2[:genotype2] == "1"
  end

  test 'removes mice if cage is removed from use' do
    # 
    @cage1 = Cage.new(cage_number:"12345", cage_type:"breeding", location:"sandler", strain:"Tau")
    @cage1.save
    assert @cage1[:in_use] == true
    
    @mouse1 = Mouse.new(cage_id:@cage1.id, sex:1, dob:"2020-01-01")
    @mouse1.save
    assert @cage1.mice.count == 1

    
  end

  # test 'validates single sex cages do not have pups' do
  #   cage1 = Cage.new(cage_number:"56565", cage_type:"single-m", location:"sandler", cage_number_changed:false, strain:"Tau")
  #   assert cage1.invalid?
  # end

end
