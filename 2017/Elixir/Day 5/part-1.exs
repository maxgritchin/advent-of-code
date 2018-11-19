_="""
The message includes a list of the offsets for each jump. Jumps are relative: -1 moves to the previous instruction, and 2 skips the next one. Start at the first instruction in the list. The goal is to follow the jumps until one leads outside the list.

In addition, these instructions are a little strange; after each jump, the offset of that instruction increases by 1. So, if you come across an offset of 3, you would move three instructions forward, but change it to a 4 for the next time it is encountered.

## Example

Positive jumps ("forward") move downward; negative jumps move upward. For legibility in this example, these offset values will be written all on one line, with the current instruction marked in parentheses. The following steps would be taken before an exit is found:

(0) 3  0  1  -3  - before we have taken any steps.
(1) 3  0  1  -3  - jump with offset 0 (that is, don't jump at all). Fortunately, the instruction is then incremented to 1.
 2 (3) 0  1  -3  - step forward because of the instruction we just modified. The first instruction is incremented again, now to 2.
 2  4  0  1 (-3) - jump all the way to the end; leave a 4 behind.
 2 (4) 0  1  -2  - go back to where we just were; increment -3 to -2.
 2  5  0  1  -2  - jump 4 steps forward, escaping the maze.
In this example, the exit is reached in 5 steps.
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
    cond do
      message |> Map.get(position) == nil -> acc
      true ->
        # get value of current position
        shift = message |> Map.get(position)
        # make shift
        new_position = position + shift
        # recurtion
        Map.put(message, position, shift + 1) # previous position value  increment by 1
        |> escape(new_position, acc + 1)
    end
  end
end

File.read!("input.dat")
|> Maze.get_steps_to_escape("\n")
