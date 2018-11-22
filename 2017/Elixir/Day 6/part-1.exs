_="""

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
  def count_of_cycles(banks, splitter) when is_bitstring(banks) do
    banks
    #|> IO.inspect(label: "Input ")
    |> String.split(splitter)
    # convert to map for O(1) access (like an array)
    |> Enum.with_index(1) |> Enum.map(fn {v, i} -> {i, String.to_integer(v)} end) |> Map.new()
    #|> IO.inspect(label: "Map ")
    |> calculation(MapSet.new())
    |> IO.inspect(label: "Count of cycles ")
  end

  defp calculation(banks, seen) do
    #IO.inspect binding(), [label: "Calculation method input params "]
    cond do
      seen |> MapSet.member?(banks) -> MapSet.size(seen) # exit if already has been seen
      true ->
        # find the biggest bank
        {current_index, value} = banks
        |> get_biggest_bank()
        #|> IO.inspect(label: "Biggest bank value ")
        # redistribute across the banks
        {inc_value, value_to_left} = calc_cycle(Map.size(banks), value)
        #|> IO.inspect(label: "Values for cycles ")
        # update
        new_banks = cond do
          inc_value > 0 ->
            banks
            |> Map.put(current_index, cond do
                value_to_left > 0 -> 1
                true -> 0
            end) # update bank value that was redistributed
            |> update_all([except: current_index, inc_by: inc_value])
            |> update([from: current_index, inc_by: 1, count: value_to_left - 1])
          true -> # not all list update
            banks
            |> Map.put(current_index, 0) # update bank value that was redistributed
            |> update([from: current_index, inc_by: 1, count: value])
        end
        #|> IO.inspect(label: "New bank(updated) ")
        # recurtion
        calculation(new_banks, MapSet.put(seen, banks))
    end
  end

  defp get_biggest_bank(banks) do
    banks
    |> Enum.reduce({0, 0}, fn
      {_, v}, {c_i, c_v} when c_v >= v -> {c_i, c_v}
      {i, v}, _ -> {i, v}
    end)
  end
  defp calc_cycle(banks_count, value_to_reduce) do
    count_of_full_cycles = div(value_to_reduce, banks_count - 1)
    count_of_left = value_to_reduce - (count_of_full_cycles * (banks_count - 1))

    {count_of_full_cycles, count_of_left}
  end

  defp update_all(banks, opts) do
    # get input values
    except_index = opts |> Keyword.get(:except)
    inc_by = opts |> Keyword.get(:inc_by)
    # update
    for {index, value} <- banks, into: %{} do
      cond do
        except_index == index -> {index, value}
        true -> {index, value + inc_by}
      end
    end
  end
  defp update(banks, opts) do
    #IO.inspect binding()
    cond do
      opts |> Keyword.get(:count) <= 0 -> banks
      true ->
        # get input values
        current_index = opts |> Keyword.get(:from)
        inc_by = opts |> Keyword.get(:inc_by)
        count = opts |> Keyword.get(:count)
        # update
        {index, value} = get_next(banks, current_index)
        update(banks |> Map.put(index, value + inc_by), [from: index, inc_by: 1, count: count - 1])
    end
  end

  defp get_next(banks, index) do
    cond do
      Map.size(banks) <= index ->
        {1, banks |> Map.get(1)} # at begin
      true ->
        {index + 1, banks |> Map.get(index + 1)}
    end
  end
end


"4	10	4	1	8	4	9	14	5	1	14	15	0	15	3	5"
|> Banks.count_of_cycles("\t")

# 12841
