defmodule Part1Tests do
  use ExUnit.Case
  Code.require_file("part-1.exs")

  test "0 3 0 1 -3 takes 5 steps" do
    assert Maze.get_steps_to_escape("0 3 0 1 -3", " ") == 5
  end
end
