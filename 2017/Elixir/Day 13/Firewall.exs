defmodule Firewall do
  def caught?({step, depth}) do
    steps_count_to_start_position = (depth - 1) * 2
    calc_steps_from_start(step, steps_count_to_start_position) == 0
  end

  defp calc_steps_from_start(a, b) when a <= b, do: rem(a, b)
  defp calc_steps_from_start(a, b), do: calc_steps_from_start(rem(a, b), b)
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

end
