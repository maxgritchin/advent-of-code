defmodule Part2Tests do
  use ExUnit.Case
  Code.require_file("part-2.exs")

  test "0 3 0 1 -3 takes 10 steps" do
    assert Maze.get_steps_to_escape("0 3 0 1 -3", " ") == 10
  end
end
