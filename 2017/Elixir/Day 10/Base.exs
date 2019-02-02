_="""
  https://adventofcode.com/2017/day/10
"""

defmodule KnotHash do
  Code.require_file(Path.join(__DIR__, "CircularList.exs"))

  @doc """
  Calculates new list based on the given lengths

  ## Examples
    iex>KnotHash.calc!([0,1,2,3], [3])
    [2,1,0,3,4]
  """
  def calc!(list, lengths) do
    list
    |> CircularList.create()
    |> calc(lengths, {1, 0})
  end
  defp calc(list, [], _), do: list
  defp calc(list, [elem_count | rest], {position, offset}) do
    {elem_count, position, offset}
    with(
      elements <- list
                    |> CircularList.get_slice(position, elem_count)
                    |> reverse_elements(),
      new_list <- CircularList.update(list, position, elements)
      ) do
        new_position = new_list
          |> CircularList.get_index(position, elem_count + offset) # arr starts from 1

        calc(new_list, rest, {new_position, offset + 1})
      end
  end

  defp reverse_elements(list) do
    Enum.reverse(list)
  end
end

# TESTS
ExUnit.start

defmodule BaseUnitTests do
  use ExUnit.Case

  test "calculates one iteration" do
    assert KnotHash.calc!([0,1,2,3], [3]) == %{1 => 2, 2 => 1, 3 => 0, 4 => 3}
  end

  test "calculates several iterations" do
    assert KnotHash.calc!([0,1,2,3,4], [3,4,1,5]) == %{1 => 3, 2 => 4, 3 => 2, 4 => 1, 5 => 0}
  end
end
