defmodule Part1Tests do
  use ExUnit.Case
  Code.require_file("part-1.exs")

  #@tag :skip
  test "0, 2, 7, and 0 takes 5 cycles" do
    assert Banks.redistribute("0 2 7 0", " ") == 5
  end
end
