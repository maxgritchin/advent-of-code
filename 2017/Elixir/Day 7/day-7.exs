_="""
  Day 7

  Task: https://adventofcode.com/2017/day/7

  Input data: https://adventofcode.com/2017/day/7/input
"""

defmodule Towers do

  @doc """
  Parse input data
  """
  def parse_input(data) when is_bitstring(data) do
    data
    |> String.split("\n")
    |> Enum.map(&String.trim(&1))
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn x ->
      {get_tower_name(x), {get_weight(x), get_sub_towers(x)}}
    end)
    |> Map.new()
    #|> IO.inspect()
  end

  @doc """
  Find the root tower
  """
  def find_root(towers) when is_map(towers) do
    # get sub mapset
    all_chld = towers
    |> Enum.map(fn {_name, {_weight, chld}} -> chld end)
    |> List.flatten()
    |> MapSet.new()
    #|> IO.inspect()

    # root should not be in the list of sub-towers
    [root_name | _] = Map.keys(towers)
    |> Enum.filter(fn tower_name -> not MapSet.member?(all_chld, tower_name) end)

    root_name
  end

  defp get_tower_name(str) do
    [tower | _] = str |> String.split("->")
    [tower_name | _] = tower |> String.split()

    tower_name
  end

  defp get_weight(str) do
    [tower | _] = str |> String.split("->")
    [_name | [wt | _]] = tower |> String.split()

    wt
    |> String.replace("(", "")
    |> String.replace(")", "")
    |> String.to_integer()
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

end

defmodule Day7.Part1 do

  @doc """
  Get the base (root) tower
  """
  def get_base_tower(input) when is_bitstring(input) do
    input
    |> Towers.parse_input()
    |> Towers.find_root()
    #|> IO.inspect(label: "Root tower ")
  end

end

defmodule Day7.Part2 do

  def get_balanced_weight(input) do
    towers = input
    |> Towers.parse_input()

    weights = Map.keys(towers)
    |> Enum.map(fn tower ->
      {weight, chld} = towers |> Map.get(tower)
      {tower, {weight, recalculate_sub_towers(towers, {weight, chld})}}
    end)
    |> Map.new()
    |> IO.inspect(label: "Weights ")

    [{tower, unbalanced} | _] = get_unbalanced_towers(towers, weights)

    {balance, diff_val} = unbalanced
    |> Enum.sort(fn({_key1, val1}, {_key2, val2}) -> val1 >= val2 end)
    |> IO.inspect(label: "Sorted balance ")
    |> get_diff()
    |> IO.inspect(label: "Diff value ")

    [{name, _} | _] = weights
    |> Enum.map(fn {name, {w, b}} -> {name, w + b} end)
    |> Enum.filter(fn {name, b} ->
      b == balance
    end)
    |> IO.inspect(label: "Name of tower with value to correct ")

    {weight, _} = towers |> Map.get(name)

    weight + diff_val |> IO.inspect(label: "Result #{weight} + #{diff_val} ")
  end

  defp recalculate_sub_towers(_, {weight, []}), do: weight
  defp recalculate_sub_towers(towers, {_weight, chld}) do
    chld
    |> Enum.reduce(0, fn chld_name, acc ->
      acc + recalculate_sub_towers(towers, Map.get(towers, chld_name))
    end)
  end

  defp get_unbalanced_towers(towers, weights) do
    Map.keys(towers)
    |> Enum.map(fn name ->
      {_weight, chld} = towers |> Map.get(name)
      {name, get_balance(weights, chld)}
    end)
    |> Enum.filter(fn {_name, {is_balanced, balance_map}} ->
      !is_balanced && Map.size(balance_map) == 2 # only one tower has wrong value
    end)
    |> Enum.map(fn {name, {_is_balanced, balance_map}} ->
      {name, Map.to_list(balance_map)}
    end)
    |> IO.inspect(label: "Unbalanced towers ")
  end

  defp get_balance(_weights, sub_towers) when length(sub_towers) in 0..1, do: {true, []}
  defp get_balance(weights, sub_towers) do
    balance_map = sub_towers
    |> Enum.map(fn x -> weights |> Map.get(x) end)
    |> Enum.map(fn {weight, balanced_weight} -> weight + balanced_weight end)
    |> Enum.reduce(%{}, fn x, acc ->
      val = Map.get(acc, x, 0) + 1
      Map.put(acc, x, val)
    end)
    |> IO.inspect(label: "Balance ")

    {Map.size(balance_map) == 1, balance_map}
  end

  defp get_diff([{first, _} | [{second, _} | _]]) do
    {second, first - second}
  end

end

ExUnit.start

defmodule Day7Tests do
  use ExUnit.Case

  #@tag :skip
  test "get base tower" do
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
    assert Day7.Part1.get_base_tower(input) == "tknk"
  end

  #@tag :skip
  test "'ugml' should have 60 as weight to balance the entire wower" do
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
    assert Day7.Part2.get_balanced_weight(input) == 60
  end

end
