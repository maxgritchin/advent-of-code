_="""
  Day 6

  Input data : https://adventofcode.com/2017/day/6/input
"""

defmodule Banks do
  def redistribute(banks, delim) when is_bitstring(banks) do
    banks
    |> String.split(delim)
    |> redistribute()
  end
  def redistribute(banks) when is_list(banks) do
    result = banks
    |> convert_to_array()
    |> process()
    |> IO.inspect(label: "Result ")
  end

  defp convert_to_array(banks) do
    banks
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.with_index(1)
    |> Enum.map(fn {v, i} -> {i, v} end)
    |> Map.new()
    |> IO.inspect(label: "Array ")
  end

  defp find_max_bank(state) do
    # find bank with the biggest amount of blocks
    state |> Enum.max_by(fn {_idx, val} -> val end)
  end

  defp process(state), do: process(state, Map.new(), false)
  defp process(state, seen, true), do: {Map.size(seen),Map.size(seen) - seen[state]}
  defp process(state, seen, _done) do
    # add as seen
    seen = seen |> Map.put(state, Map.size(seen))
    # find bank to redistribute
    bank_to_redistribute = state |> find_max_bank()
    #|> IO.inspect(label: "Bank to redistribute ")
    # update
    new_state = state
    |> make(bank_to_redistribute)
    #|> IO.inspect(label: "New state ")
    # recursion
    process(new_state, seen, already_seen?(seen, new_state))
  end

  defp already_seen?(seen_map, state) do
    seen_map |> Map.has_key?(state)
  end

  defp make(state, {index, blocks}) do
    # calc add value number
    add_val = div(blocks, Map.size(state) - 1)
    blocks_left = blocks - (add_val * (Map.size(state) - 1))
    # update
    state
    |> update(add_val, index, (Map.size(state) - 1), blocks_left)
  end

  defp update(state, _add, from, 0, blocks_left) when blocks_left in [0, 1] do
    state
    |> set_elem(from, blocks_left)
  end
  defp update(state, _add, from, 0, blocks_left) when blocks_left > 1 do # need to redistribute a little bit more
    state
    |> update(1, from, blocks_left - 1, 1)
  end
  defp update(state, 0, from, _count, block_left) do
    state
    |> update(1, from, block_left, 0)
  end
  defp update(state, add, from, count, blocks_left) do
    # element to update
    {idx, val} = state |> get_elem(from + count)
    # update
    new_state = state |> set_elem(idx, val + add)
    # recurtion
    update(new_state, add, from, count - 1, blocks_left)
  end

  defp get_elem(state, index) do
    cond  do
      Map.size(state) >= index ->
        {index, state |> Map.get(index)}
      true ->
        idx = index - Map.size(state)
        {idx, state |> Map.get(idx)}
    end
  end
  defp set_elem(state, index, value) do
    cond  do
      Map.size(state) >= index ->
        state |> Map.put(index, value)
      true ->
        state |> Map.put(index - Map.size(state), value)
    end
  end
end

ExUnit.start()

defmodule Part1Tests do
  use ExUnit.Case

  test "[0, 2, 7, 0] takes 5 cycles" do
    assert {5, _} = Banks.redistribute("0 2 7 0", " ")
  end
end

defmodule Part2Tests do
  use ExUnit.Case

  test "[0, 2, 7, 0] takes 4 cycles from the seen value" do
    assert {_, 4} = Banks.redistribute("0 2 7 0", " ")
  end
end
