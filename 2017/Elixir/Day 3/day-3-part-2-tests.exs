defmodule Day3Part2Tests do
  use ExUnit.Case
  Code.require_file("day-3-part-2.exs")

  test "input 1 expected result is 1" do
    assert Calculator.get_first_value_that_larger_than(1) == 2
  end

  test "input 4 expected result is 5" do
    assert Calculator.get_first_value_that_larger_than(4) == 5
  end

  test "input 23 expected result is 25" do
    assert Calculator.get_first_value_that_larger_than(23) == 25
  end

  test "input 747 expected result is 806" do
    assert Calculator.get_first_value_that_larger_than(747) == 806
  end
end
