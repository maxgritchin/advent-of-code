defmodule HexGrid do
  @doc """
  Calculate the fewest number of steps in a hex grid to reach the last point in the given path
  """
  def fewest_number_of_steps(path) do
    start_point = {0,0}
    Enum.reduce(path, start_point, &calculate_position(&1, &2))
    |> calc_min_steps_count
  end

  @doc """
  Calculate the furthest number of steps from the start point
  """
  def furthers_number_of_steps(path) do
    {ms, _} = Enum.reduce(path, {0, {0, 0}}, fn s, {max_steps, point} ->
      new_point = calculate_position(s, point)
      {get_further_value(max_steps, new_point), new_point}
    end)

    ms
  end

  defp calculate_position("ne", {x, y}),  do: {x, y + 1}
  defp calculate_position("n", {x, y}),   do: {x - 1, y + 1}
  defp calculate_position("nw", {x, y}),  do: {x - 1, y}
  defp calculate_position("se", {x, y}),  do: {x + 1, y}
  defp calculate_position("s", {x, y}),   do: {x + 1, y - 1}
  defp calculate_position("sw", {x, y}),  do: {x, y - 1}

  defp calc_min_steps_count({x, y}) when abs(x) >= abs(y), do: abs(x)
  defp calc_min_steps_count({x, y}) when abs(x) < abs(y), do: abs(y)

  defp get_further_value(last_max, {a, b}) do
      a = abs(a)
      b = abs(b)
      max = if (a >= b), do: a, else: b
      if (max > last_max), do: max, else: last_max
  end
end

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
