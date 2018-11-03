defmodule Captcha do
  @moduledoc """
    This is a module to solve captcha of Day 1
  """

  @doc """
    Read data from file and calcualte sum of dubled nums in a row
  """
  def calculate_from_file(file_name) do
    read_file_data(file_name)
    |> calculate_data
  end

  @doc """
    Calculate sum of dubled nums in a row

    ## Example

    '1122' -> 1 + 2 = 3
    '1231' -> 1
    '1234' -> 0

  """
  def calculate_data(input_string) do
    get_list(input_string)
    |> add_last_num_as_first
    |> get_doubled_nums(nil)
    |> Enum.sum
  end

  defp read_file_data(path), do: File.read!(path)

  defp get_list(data) when is_binary(data) do
    String.graphemes(data)
  end

  defp add_last_num_as_first(data) do
    cond do
      data == nil or data == [] -> []
      true ->
        last_idx = Enum.count(data) - 1
        last = Enum.at(data, last_idx)
        [last | data]
    end
  end

  defp get_doubled_nums(data, prev_value, acc \\ [])
  defp get_doubled_nums([head | rest], prev_value, acc) do
    cond do
      head == prev_value ->
        {int_val, ""} = Integer.parse(head)
        get_doubled_nums(rest, head, [int_val | acc])
      rest == [] -> acc
      true -> get_doubled_nums(rest, head, acc)
    end
  end

  defp get_doubled_nums([], prev_value, acc) do
    acc
  end
end

IO.puts("##### TESTS #####")
IO.puts "Empty string produces #{Captcha.calculate_data("")} and expected 0"
IO.puts "'1122' produces #{Captcha.calculate_data("1122")} and expected 3"
IO.puts "'1111' produces #{Captcha.calculate_data("1111")} and expected 4"
IO.puts "'1234' produces #{Captcha.calculate_data("1234")} and expected 0"
IO.puts "'91212129' produces #{Captcha.calculate_data("91212129")} and expected 9"

# get result
IO.puts("##### CALCULATION #####")
IO.puts Captcha.calculate_from_file "../Tasks/Day 1/input.dat"
