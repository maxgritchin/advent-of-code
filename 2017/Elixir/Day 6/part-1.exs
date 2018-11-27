_ = """

The debugger would like to know how many redistributions can be done before a blocks-in-banks configuration is produced that has been seen before.

## Example

The banks start with 0, 2, 7, and 0 blocks. The third bank has the most blocks, so it is chosen for redistribution.

Starting with the next bank (the fourth bank) and then continuing to the first bank, the second bank, and so on, the 7 blocks are spread out over the memory banks. The fourth, first, and second banks get two blocks each, and the third bank gets one back. The final result looks like this: 2 4 1 2.

Next, the second bank is chosen because it contains the most blocks (four). Because there are four memory banks, each gets one block. The result is: 3 1 2 3.

Now, there is a tie between the first and fourth memory banks, both of which have three blocks. The first bank wins the tie, and its three blocks are distributed evenly over the other three banks, leaving it with none: 0 2 3 4.

The fourth bank is chosen, and its four blocks are distributed such that each of the four banks receives one: 1 3 4 1.

The third bank is chosen, and the same thing happens: 2 4 1 2.

At this point, we've reached a state we've seen before: 2 4 1 2 was already seen. The infinite loop is detected after the fifth block redistribution cycle, and so the answer in this example is 5.

## Task

Given the initial block counts in your puzzle input, how many redistribution cycles must be completed before a configuration is produced that has been seen before?
"""

defmodule Banks do
  def redistribute(banks, delim) when is_bitstring(banks) do
    banks
    |> String.split(delim)
    |> redistribute()
  end
  def redistribute(banks) when is_list(banks) do
    banks
    |> convert_to_array()
    |> process()
    |> IO.inspect(label: "Count of redistribution processes ")
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

  defp process(state), do: process(state, MapSet.new(), false)
  defp process(_state, seen, true), do: MapSet.size(seen)
  defp process(state, seen, _done) do
    # add as seen
    seen = seen |> MapSet.put(state)
    # find bank to redistribute
    bank_to_redistribute = state |> find_max_bank()
    #|> IO.inspect(label: "Bank to redistribute ")
    # update
    new_state = state
    |> make(bank_to_redistribute)
    #|> IO.inspect(label: "New state ")
    # recursion
    #IO.gets("continue...")
    process(new_state, seen, MapSet.member?(seen, new_state))
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

"4	10	4	1	8	4	9	14	5	1	14	15	0	15	3	5"
|> Banks.redistribute("\t")

# 12841
