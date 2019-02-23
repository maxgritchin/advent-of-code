defmodule Firewall do
  @doc """
  Check if package is caught
  """
  def caught?({step, depth}) do
    steps_count_to_start_position = (depth - 1) * 2
    calc_steps_from_start(step, steps_count_to_start_position) == 0
  end

  defp calc_steps_from_start(a, b) when a <= b, do: rem(a, b)
  defp calc_steps_from_start(a, b), do: calc_steps_from_start(rem(a, b), b)

  @doc """
  Calculate the fewest number of picoseconds to pass through the firewall
  """
  def fewest_number_of_picoseconds(state, pause_value) do
    cond do
      Enum.all?(state, fn x -> not caught?(x) end) ->
        pause_value
      true -> # add one picosecond
        new_state = Enum.map(state, fn {s, d} -> {s + 1, d} end)
        fewest_number_of_picoseconds(new_state, pause_value + 1)
    end
  end
end

# TESTS
ExUnit.start()

defmodule FirewallTests do
  use ExUnit.Case

  test "should return 2 caught positions" do
    # arrange
    input = [
      {0, 3},
      {1, 2},
      {4, 4},
      {6, 4}
    ]

    # act
    catches_count = input
      |> Enum.filter(fn x -> Firewall.caught?(x) end)
      |> length

    # assert
    assert catches_count == 2
  end

    test "should return 10 pause value" do
    # arrange
    input = [
      {0, 3},
      {1, 2},
      {4, 4},
      {6, 4}
    ]

    # act
    pause = input |> Firewall.fewest_number_of_picoseconds(0)

    # assert
    assert pause == 10
  end

end
