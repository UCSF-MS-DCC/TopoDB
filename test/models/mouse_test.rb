require 'test_helper'

class MouseTest < ActiveSupport::TestCase
  test "validates uniqueness of designations within a strain" do
    mouse = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"LL", designation:"F001RL", strain:"ATXN1")
    assert mouse.invalid?
  end
  test "allows duplicate designations in different strains" do
    mouse = Mouse.new(cage_id:Cage.first.id, sex:"F", genotype:"-/-", dob:"04/12/2019", weaning_date:"05/02/2019", tail_cut_date:nil, ear_punch:"LL", designation:"F001RL", strain:"Tau")
    assert mouse.valid?
  end

end
