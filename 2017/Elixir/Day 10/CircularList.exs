
defmodule CircularList do
  @doc """
  Create a circular list based on a list

  ## Description
    It takes a list and makes an array representation to make access time as O(1)

  ## Examples
    iex>CircularList.create([10,20,30])
    %{1=>10, 2 => 20, 3=>30}
  """
  def create(list) when is_list(list) do
    1..length(list) |> Stream.zip(list) |> Enum.into(%{})
  end

  @doc """
  Get values from map in the order
  """
  def get_values(arr) when is_map(arr) do
    1..Map.size(arr) |> Enum.map(fn idx -> Map.get(arr, idx) end)
  end

  @doc """
  Get the index from the given position with shift

  ## Examples
    iex>CircularList.get_index(%{1=>10, 2=>20, 3=>30}, 2, 1)
    3
  """
  def get_index(_list, position, shift) when shift <= 0, do: position
  def get_index(list, position, shift) do
    cond do
      (shift > Map.size(list)) ->
        get_index(list, position, rem(shift, Map.size(list)))
      (position + shift) > Map.size(list) ->
        (position + shift) - Map.size(list)
      true ->
        position + shift
    end
  end

  @doc """
  Get elements from the given position and size

  ## Examples
    iex>CircularList.get_slice(CircularList.create([1,2,3]), 0, 2)
    [1,2]
  """
  def get_slice(_list, _from, size) when size <= 0, do: []
  def get_slice(list, from, size) when from <= 0, do: get_slice(list, 1, size, [])
  def get_slice(list, from, size), do: get_slice(list, from, size, [])

  defp get_slice(_list, _from, size, result) when size == 0, do: result |> Enum.reverse()
  defp get_slice(list, from, size, result) do
    cond do
      Map.size(list) < size ->
        get_slice(list, from, Map.size(list), result)
      Map.has_key?(list, from) ->
        element = list |> Map.get(from)
        next_idx = get_index(list, from, 1)
        get_slice(list, next_idx, size - 1, [element | result])
      true ->
        get_slice(list, from, 0, result)
    end
  end

  @doc """
  Insert elements to the circular list

  ## Examples
    iex>CircularList.insert(%{1 => 1}, 1, [10])
    %{1 => 10}
  """
  def update(list, _position, []), do: list
  def update(list, position, [elm | rest]) do
    cond do
      Map.has_key?(list, position) ->
        next_position = get_index(list, position, 1)
        update(Map.put(list, position, elm), next_position, rest)
      true ->
        list
    end
  end
end

# TESTS
ExUnit.start

defmodule CircularListUnitTests do
  use ExUnit.Case

  test "create a circular list" do
    assert CircularList.create([]) == %{}
    assert CircularList.create([10,20]) == %{1 => 10, 2 => 20}
  end

  test "get elements from circular list" do
    assert  CircularList.get_slice(%{1 => 10, 2 => 20}, 1, 3) == [10,20]
    assert  CircularList.get_slice(%{1 => 10, 2 => 20}, 1, 1) == [10]
    assert  CircularList.get_slice(%{1 => 10, 2 => 20, 3 => 30}, 2, 3) == [20,30,10]
    assert  CircularList.get_slice(%{1 => 10, 2 => 20, 3 => 30}, 3, 3) == [30,10,20]
  end

  test "get the next element index" do
    assert CircularList.get_index(%{1 => 10, 2 => 20, 3 => 30}, 2, 1) == 3
    assert CircularList.get_index(%{1 => 10, 2 => 20, 3 => 30}, 3, 2) == 2
    assert CircularList.get_index(%{1 => 10, 2 => 20, 3 => 30}, 3, 3) == 3
    assert CircularList.get_index(%{1 => 10, 2 => 20, 3 => 30}, 2, 10) == 3
  end

  test "update elements values into circular list" do
    assert CircularList.update(%{1 => 1}, 1, [10]) == %{1 => 10}
    assert CircularList.update(%{1 => 1}, 2, [10]) == %{1 => 1}
    assert CircularList.update(%{1 => 1}, 1, [20, 10]) == %{1 => 10}
    assert CircularList.update(%{1 => 1, 2 => 2, 3 => 3}, 2, [10]) == %{1 => 1, 2 => 10, 3 => 3}
    assert CircularList.update(%{1 => 1}, 1, []) == %{1 => 1}
  end

end
