_="""
  Day 7

  Task: https://adventofcode.com/2017/day/7

  Input data: https://adventofcode.com/2017/day/7/input
"""

defmodule Day7 do
  def get_last_tower(input) when is_bitstring(input) do
    input
    |> parse_input()
    |> find_root()
  end

  defp parse_input(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim(&1))
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn x -> {get_tower_name(x), get_sub_towers(x)} end)
    #|> IO.inspect()
  end

  defp get_tower_name(str) do
    [tower | _] = str |> String.split("->")
    [name | _] = tower |> String.split()
    name
  end

  defp get_sub_towers(str) do
    [_ | sub] = str |> String.split("->")
    cond do
      sub == [] -> []
      true ->
        [st | _] = sub
        st
        |> String.split(",")
        |> Enum.map(&String.trim(&1))
    end
  end

  defp find_root(data) do
    # create MapSet with all sub towers
    all_sub_set = data
    |> Enum.map(fn {_, sub} -> sub end)
    |> List.flatten()
    |> MapSet.new()

    # find root
    [{root, _} | _] = data
    |> Enum.filter(fn {t, _} -> not MapSet.member?(all_sub_set, t) end)

    # found
    root
  end
end

ExUnit.start

defmodule Day7Part1 do
  use ExUnit.Case

  test "get last tower" do
    # arrange
    input = "
      pbga (66)
      xhth (57)
      ebii (61)
      havc (66)
      ktlj (57)
      fwft (72) -> ktlj, cntj, xhth
      qoyq (66)
      padx (45) -> pbga, havc, qoyq
      tknk (41) -> ugml, padx, fwft
      jptl (61)
      ugml (68) -> gyxo, ebii, jptl
      gyxo (61)
      cntj (57)
    "
    # assert
    assert Day7.get_last_tower(input) == "tknk"
  end
end
