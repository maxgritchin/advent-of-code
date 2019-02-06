_="""
  https://adventofcode.com/2017/day/10
"""

defmodule KnotHash do
  Code.require_file(Path.join(__DIR__, "CircularList.exs"))
  Code.require_file(Path.join(__DIR__, "Ascii.exs"))

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

  def get_hash(input) do
    lengths = input
    # duplicate codepoints 64 rounds
    |> AsciiCodes.generate(64)

    sparse_hash = KnotHash.calc!(Enum.to_list(0..255), lengths) # sparse hash
    |> CircularList.get_values()

    dense_hash = sparse_hash
    |> AsciiCodes.get_dense_hash() # dense hash

    dense_hash
    |> Enum.reduce("", fn x, acc -> acc <> <<x>> end)
    |> Base.encode16(case: :lower) # hexadeciaml representation
  end

  defp reverse_elements(list) do
    Enum.reverse(list)
  end
end

# TESTS
ExUnit.start

defmodule KnotHashUnitTests do
  use ExUnit.Case

  test "calculates one iteration" do
    assert KnotHash.calc!([0,1,2,3], [3]) == %{1 => 2, 2 => 1, 3 => 0, 4 => 3}
  end

  test "calculates several iterations" do
    assert KnotHash.calc!([0,1,2,3,4], [3,4,1,5]) == %{1 => 3, 2 => 4, 3 => 2, 4 => 1, 5 => 0}
  end

  test "get Knot Hash representation" do
    assert KnotHash.get_hash("") == "a2582a3a0e66e6e86e3812dcb672a272"
    assert KnotHash.get_hash("AoC 2017") == "33efeb34ea91902bb2f59c9920caa6cd"
    assert KnotHash.get_hash("1,2,3") == "3efbe78a8d82f29979031a4aa0b16a9d"
    assert KnotHash.get_hash("1,2,4") == "63960835bcdc130f0b66d7ff4f6a5a8e"
  end
end
