_="""
Now, the jumps are even stranger: after each jump, if the offset was three or more, instead decrease it by 1. Otherwise, increase it by 1 as before.

Using this rule with the above example, the process now takes 10 steps, and the offset values after finding the exit are left as 2 3 2 3 -1.

## Task

How many steps does it now take to reach the exit?
"""
defmodule Maze do
  def get_steps_to_escape(message, split_char) when is_bitstring(message) do
    convert_to_map = fn list ->
      list
      |> Enum.with_index(1)
      |> Enum.map(fn {v,i}->{i,String.to_integer(v)} end)
      |> Map.new()
    end

    message
    #|> IO.inspect(label: "Input message ")
    |> String.split(split_char)
    |> convert_to_map.()
    #|> IO.inspect(label: "Converted message ")
    |> escape(1, 0) # from first position
    |> IO.inspect(label: "Steps count to escape ")
  end

  defp escape(message, position, acc) do
    calc_shift = fn
      x when x >= 3 -> x - 1
      x -> x + 1
    end

    #IO.inspect binding()
    cond do
      message |> Map.get(position) == nil -> acc
      true ->
        # get value of current position
        shift = message |> Map.get(position)
        # make shift
        new_position = position + shift
        # recurtion
        Map.put(message, position, calc_shift.(shift)) # previous position value  increment by 1
        |> escape(new_position, acc + 1)
    end
  end
end

File.read!("input.dat")
|> Maze.get_steps_to_escape("\n")
