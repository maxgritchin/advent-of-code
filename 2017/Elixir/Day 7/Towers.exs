defmodule Towers do
  @doc """
  Parse towers info
  """
  def parse_towers_info(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn row -> parse_row(row) end)
    |> Map.new()
  end

  @doc """
  Generate towers structure
  """
  def get_base_tower(data) when is_map(data) do
    {:ok, base_name} = data
    |> Enum.reduce([], fn {_k, info}, acc -> [info.sub_towers | acc] end)
    |> List.flatten()
    |> MapSet.new()
    |> find_base_tower(Map.keys(data))

    base_name
  end
  def get_base_tower(str) when is_bitstring(str) do
    str |> parse_towers_info() |> get_base_tower()
  end

  defp find_base_tower(_, []), do: {:error, "Base tower not found!"}
  defp find_base_tower(all_sub_towers, [name | rest]) do
    cond do
      not MapSet.member?(all_sub_towers, name) ->
        {:ok, name}
      true ->
        find_base_tower(all_sub_towers, rest)
    end
  end

  defp parse_row(row) do
    [raw_tower | raw_sub_towers] = row |> String.split("->")
    {name, weight} = parse_tower(raw_tower)
    sub_towers = parse_sub_towers(raw_sub_towers)

    {name, %{weight: weight, sub_towers: sub_towers}}
  end

  defp parse_tower(raw_tower) do
    [name | _] = Regex.run(~r/\w+/, raw_tower)
    [weight | _] = Regex.run(~r/\d+/, raw_tower)
    {name, String.to_integer(weight)}
  end

  defp parse_sub_towers([]), do: []
  defp parse_sub_towers([raw_sub_towers | _]), do: raw_sub_towers |> String.split(",") |> Enum.map(&String.trim/1)

  @doc """
  Get balanced weight
  """
  def get_balanced_weight(data) when is_bitstring(data) do
    # parse tower info from the given string
    towers = data
    |> parse_towers_info()

    # calculate balane for each tower
    towers_balance = towers
    |> Enum.map(fn {name, _info} ->
      {name, calc_tower_balance(name, towers)}
    end)
    |> Enum.into(%{})

    # find unbalanced tower and make it balanced
    unbalanced = find_unbalanced(towers, towers_balance)

    # get invalid tower and values
    [{tower_name, unbalanced_value} | _] = unbalanced |> Enum.filter(fn {_name, wt} ->
      unbalanced
      |> Map.values()
      |> Enum.filter(fn v -> wt == v end)
      |> Enum.count() == 1
    end) #|> IO.inspect(label: "AAA ")

    [balanced_value | _] = unbalanced
    |> Map.values()
    |> MapSet.new()
    |> Enum.filter(fn x -> x != unbalanced_value end)

    # get diff
    diff = unbalanced_value - balanced_value

    # calc balanced value

    Map.get(towers, tower_name) #|> IO.inspect(label: "BBB ")
    Map.get(towers, tower_name).weight - diff
  end

  defp calc_tower_balance(name, all_towers) do
    info = Map.get(all_towers, name)
    info.weight + Enum.reduce(info.sub_towers, 0, fn n, acc ->
      acc + calc_tower_balance(n, all_towers)
    end)
  end

  defp find_unbalanced(all_towers, balance) do
    unbalanced = all_towers
    |> Enum.map(fn {name, %{sub_towers: st}} ->
      {name, %{balance: Enum.map(st, &{&1, Map.get(balance, &1)})}}
    end)
    |> Enum.filter(fn {_name, info} ->
      Enum.map(info.balance, fn {_name, wt} -> wt end)
      # values are not the same
      |> MapSet.new()
      |> MapSet.size() > 1
    end)

    # unbalanced
    # |> IO.inspect(label: "UNBALANCED")

    {_name, %{balance: balance}} = unbalanced
    |> hd() # todo need to find tower near the root

    balance
    |> Map.new()
  end
end

# TESTS
ExUnit.start()

defmodule TowersUnitTests do
  use ExUnit.Case

  test "generate towers structure from the given string data and return the base tower" do
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
    assert Towers.get_base_tower(input) == "tknk"
  end

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
    assert Towers.get_balanced_weight(input) == 60
  end
end
