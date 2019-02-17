_="""
  https://adventofcode.com/2017/day/11
"""

defmodule HexGrid do
  def fewest_number_of_steps(path) do
    start_point = {0,0}

    Enum.reduce(path, start_point, &calculate_position(&1, &2))
    |> IO.inspect(label: "POINT ")
    |> calc_min_steps_count
  end

  defp calculate_position("ne", {x, y}),  do: {x, y + 1}
  defp calculate_position("n", {x, y}),   do: {x - 1, y + 1}
  defp calculate_position("nw", {x, y}),  do: {x - 1, y}
  defp calculate_position("se", {x, y}),  do: {x + 1, y}
  defp calculate_position("s", {x, y}),   do: {x + 1, y - 1}
  defp calculate_position("sw", {x, y}),  do: {x, y - 1}

  defp calc_min_steps_count({x, y}) when abs(x) >= abs(y), do: abs(x)
  defp calc_min_steps_count({x, y}) when abs(x) < abs(y), do: abs(y)
end

# RUN
File.read!(Path.join(__DIR__, "input.dat"))
|> String.trim
|> String.split(",")
|> HexGrid.fewest_number_of_steps
|> IO.inspect(label: "Result")

# TESTS
ExUnit.start

defmodule HexGridTests do
  use ExUnit.Case

  test "ne,ne,ne is 3 steps away" do
    assert HexGrid.fewest_number_of_steps(["ne", "ne", "ne"]) == 3
  end

  test "ne,ne,sw,sw is 0 steps away (back where you started)." do
    assert HexGrid.fewest_number_of_steps(["ne", "ne", "sw", "sw"]) == 0
  end

  test "ne,ne,s,s is 2 steps away (se,se)." do
    assert HexGrid.fewest_number_of_steps(["ne", "ne", "s", "s"]) == 2
  end

  test "se,sw,se,sw,sw is 3 steps away (s,s,sw)." do
    assert HexGrid.fewest_number_of_steps(["se", "sw", "se", "sw", "sw"]) == 3
  end
end
