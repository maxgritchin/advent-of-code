defmodule Part1Tests do
  use ExUnit.Case
  Code.require_file("part-1.exs")

  test "pharse has duplicates" do
    assert Analizer.has_duplicates("aa bb cc dd ee aaa") == false
  end

  test "phrase does not have duplicates" do
    assert Analizer.has_duplicates("aa bb cc dd aa") == true
  end
end
