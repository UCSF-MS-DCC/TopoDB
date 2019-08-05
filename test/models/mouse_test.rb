require 'test_helper'

class MouseTest < ActiveSupport::TestCase
  test "validates designation is available (not in use by a living mouse in the same strain)" do
    mouse1 = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"LL", designation:"F001RL", strain:"ATXN1", euthanized:false)
    assert mouse1.invalid?
    mouse2 = Mouse.new(cage_id:Cage.first.id, sex:"M", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"RR", designation:"M222RR", strain:"ATXN1", euthanized:false)
    assert mouse2.valid?
  end
  test "allows duplicate designations in different strains" do
    mouse = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"LL", designation:"F001LL", strain:"Tau", euthanized:false)
    assert mouse.valid?
  end
  test "restricts ear punch patterns to a defined and enumerated set" do
    mouse1 = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"RL", designation:"F025RL", strain:"Tau")
    mouse2 = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"LeftRight", designation:"F854LR", strain:"Tau")
    mouse3 = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"NRL", designation:"M555NRL", strain:"Tau")

    assert mouse1.valid?
    assert mouse2.invalid?
    assert mouse3.invalid?
  end
  test "ensures designations begin with either F or M and that this matches the sex of the mouse" do
    mouse1 = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"RL", designation:"F025RL", strain:"Tau")
    mouse2 = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"RL", designation:"M333RL", strain:"Tau")

    assert mouse1.valid?
    assert mouse2.invalid?
  end
  test "ensures designations end with the correct earpunch pattern" do
    mouse1 = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"RL", designation:"F025RL", strain:"Tau")
    mouse2 = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"RL", designation:"F025RRLL", strain:"Tau")

    assert mouse1.valid?
    assert mouse2.invalid?

  end

end
