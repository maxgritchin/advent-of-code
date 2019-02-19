defmodule DigitalPlumber do
  @doc """
  Calculates number of programs that contains the given ID
  """
  def count_of_programs(input, id \\ 0) when is_map(input) and is_integer(id) do
    set = MapSet.new([id])
    input |> find_all_related([id], set) |> MapSet.size
  end

  defp find_all_related(_input, [], set), do: set
  defp find_all_related(input, [id | rest], set) do
    elements = Map.get(input, id)
    |> Enum.filter(fn x -> not MapSet.member?(set, x) end)

    new_set = MapSet.union(set, MapSet.new(elements))

    find_all_related(input, [elements | rest] |> List.flatten(), new_set)
  end

  @doc """
  Calculate count of groups
  """
  def count_of_groups(input) when is_map(input) do
    # find first group
    set = {1, input |> find_all_related([0], MapSet.new([0]))}

    {groups_count, _} = input |> Enum.reduce(set, fn {key, val}, {acc, seen} ->
      cond do
        MapSet.member?(seen, key) ->
          {acc, seen}
        true ->
          new_group = input |> find_all_related([key], MapSet.new([key]))
          {acc + 1, MapSet.union(seen, new_group)}
      end
    end)

    groups_count
  end


end

# TESTS
ExUnit.start

defmodule DigitalPlumberTests do
  use ExUnit.Case

  test "calculates programs that contains no Program 0" do
    # arrange
    input = %{
      0 => [2],
      1 => [1],
      2 => [0,3,4],
      3 => [2,4],
      4 => [2,3,6],
      5 => [6],
      6 => [4,5]
    }

    # act, assert
    assert DigitalPlumber.count_of_programs(input, 0) == 6
  end

  test "calculates groups" do
    # arrange
    input = %{
      0 => [2],
      1 => [1],
      2 => [0,3,4],
      3 => [2,4],
      4 => [2,3,6],
      5 => [6],
      6 => [4,5]
    }

    # act, assert
    assert DigitalPlumber.count_of_groups(input) == 2
  end
end
