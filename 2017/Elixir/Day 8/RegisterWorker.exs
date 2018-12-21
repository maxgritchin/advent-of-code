_="""
  https://adventofcode.com/2017/day/8
"""
defmodule RegisterWorker do
  Code.require_file(Path.join(__DIR__, "Calculator.exs"))

  def get_lagest_value(input) when is_bitstring(input) do
    input
    |> get_registers()
    #|> IO.inspect(label: "-- registers")
    |> Enum.max_by(fn {_, v} -> v end)
  end

  def parse(data) when is_bitstring(data) do
    data
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn row -> parse_row(row) end)
  end

  defp parse_row(data) when length(data) == 0, do: :empty
  defp parse_row(row) do
    [op | [ condition | _] ] = row |> String.split("if")
    [register | [make | [value | _]]] = op |> String.split()

    condition = parse_condition(condition)

    %Calculator.Operation{register: register, make: make, value: String.to_integer(value), condition: condition}
  end

  defp parse_condition(condition) do
    [register | [operator | [value | _]]] = condition |> String.split()

    %Calculator.Condition{register: register, operator: operator, value: String.to_integer(value)}
  end

  def get_registers(data) when is_bitstring(data) do
    data
    |> parse()
    |> Calculator.refresh_values(Map.new())
  end
end

# part 1
File.read!(Path.join(__DIR__, "data.dat"))
|> RegisterWorker.get_lagest_value()
|> IO.inspect(label: "Part 1 result is ")

# TESTS
ExUnit.start

defmodule RegisterWorkerTests do
  use ExUnit.Case

  test "parse input row" do
    # arrange
    row = "b inc 5 if a > 1"

    # act
    [operation | _] = RegisterWorker.parse(row)

    # assert
    assert operation.register == "b"
    assert operation.make == "inc"
    assert operation.value == 5
    assert operation.condition.register == "a"
    assert operation.condition.operator == ">"
    assert operation.condition.value == 1
  end

  test "the lagest value in any register should be 1" do
    # arrange
    input = "
      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10
    "
    # assert
    assert RegisterWorker.get_lagest_value(input) == {"a", 1}
  end
end
