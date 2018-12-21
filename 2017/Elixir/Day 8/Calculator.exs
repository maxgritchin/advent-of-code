defmodule Calculator do
  defmodule Condition do
    defstruct register: nil, operator: nil, value: nil
    @type t :: %Condition{register: String.t, operator: String.t, value: Integer.t}
  end
  defmodule Operation do
    defstruct register: nil, make: nil, value: nil, condition: %Condition{}
    @type t :: %Operation{register: String.t, make: String.t, value: Integer.t, condition: Condition.t}
  end

  def refresh_values([], storage), do: storage
  def refresh_values([operation = %Operation{} | rest], storage) when is_map(storage) do
    # add regesters from operation
    new_storage = storage
    |> add_register(operation.register)
    |> add_register(operation.condition.register)
    |> make_operation(operation)
    # another operation
    refresh_values(rest, new_storage)
  end

  defp add_register(storage, reg_name) do
    if !Map.has_key?(storage, reg_name), do: Map.put_new(storage, reg_name, 0), else: storage
  end

  defp should_make_operation(condition = %Condition{}, storage) do
    curr_value = Map.get(storage, condition.register)
    case condition.operator do
      "==" -> curr_value == condition.value
      "!=" -> curr_value != condition.value
      ">" -> curr_value > condition.value
      "<" -> curr_value < condition.value
      ">=" -> curr_value >= condition.value
      "<=" -> curr_value <= condition.value
    end
  end

  defp make_operation(storage, operation = %Operation{}) do
    if operation.condition |> should_make_operation(storage) do
      case operation.make do
        "inc" ->
          Map.update!(storage, operation.register, fn v -> v + operation.value end)
        "dec" ->
          Map.update!(storage, operation.register, fn v -> v - operation.value end)
        _ ->
          storage
      end
    else
      storage
    end
  end
end

ExUnit.start

defmodule CalculatorTests do
  use ExUnit.Case

  test "all registers starts from 0" do
    # arrange
    operations = [%Calculator.Operation{
      register: "b",
      make: "inc",
      value: 5,
      condition: %Calculator.Condition{
        register: "a",
        operator: ">",
        value: 1
      }
    }]

    # act
    registers = Calculator.refresh_values(operations, %{})

    # assert
    assert Map.size(registers) == 2
    assert registers |> Map.get("a") == 0
    assert registers |> Map.get("b") == 0
  end

  test "calculate registers" do
    # arrange
    operations = [
      %Calculator.Operation{
        register: "b",
        make: "inc",
        value: 5,
        condition: %Calculator.Condition{
          register: "a",
          operator: ">",
          value: 1
        }
      },
      %Calculator.Operation{
        register: "a",
        make: "inc",
        value: 1,
        condition: %Calculator.Condition{
          register: "b",
          operator: "<",
          value: 5
        }
      },
      %Calculator.Operation{
        register: "c",
        make: "dec",
        value: -10,
        condition: %Calculator.Condition{
          register: "a",
          operator: ">=",
          value: 1
        }
      },
      %Calculator.Operation{
        register: "c",
        make: "inc",
        value: -20,
        condition: %Calculator.Condition{
          register: "c",
          operator: "==",
          value: 10
        }
      }
    ]

    # act
    registers = Calculator.refresh_values(operations, %{})

    # assert
    assert Map.size(registers) == 3
    assert registers |> Map.get("a") == 1
    assert registers |> Map.get("b") == 0
    assert registers |> Map.get("c") == -10
  end
end
