defmodule Captcha do
  def calculation(list) do
    cond do
      [] == list -> []
      true ->
        shift = div(String.length(list), 2)
        String.graphemes(list)
          |> double_list
          |> get_values(shift, 0)
          |> Enum.sum()
    end
  end

  defp double_list(list) do
    [list ++ list]
    |> List.flatten()
  end

  defp get_values(list, shift, idx, acc \\ []) do
    cond do
      idx == (shift * 2) -> acc # base case
      true ->
        [h | tail] = list

        get_values(tail, shift, idx + 1,
        cond do
          Enum.at(list, shift) == h ->
            {int_val, ""} = Integer.parse(h)
            [int_val | acc]
          true -> acc
        end)
    end
  end
end

# test
# input = "123123" # expect 12

File.read!("../Tasks/Day 1/input.dat")
|> Captcha.calculation
|> IO.inspect
