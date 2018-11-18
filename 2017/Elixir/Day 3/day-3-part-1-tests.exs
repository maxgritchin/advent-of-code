defmodule Day3Part1Tests do
  use ExUnit.Case
  Code.require_file("day-3-part-1.exs")

  test "steps count when start from 1 is equal to 0" do
    assert StepsCounter.calculate(1) == 0
  end

  test "steps count when start from 12 is equal to 3" do
    assert StepsCounter.calculate(12) == 3
  end

  test "steps count when start from 23 is equal to 2" do
    assert StepsCounter.calculate(23) == 2
  end

  test "steps count when start from 1024 is equal to 31" do
    assert StepsCounter.calculate(1024) == 31
  end
end
