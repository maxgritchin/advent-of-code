_="""
  https://adventofcode.com/2017/day/3

  You come across an experimental new kind of memory stored on an infinite two-dimensional grid.

  Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while spiraling outward.

  While this is very space-efficient (no squares are skipped), requested data must be carried back to square 1 (the location of the only access port for this memory system) by programs that can only move up, down, left, or right. They always take the shortest path: the Manhattan Distance between the location of the data and square 1.

  ## Example

  17  16  15  14  13
  18   5   4   3  12
  19   6   1   2  11
  20   7   8   9  10
  21  22  23---> ...

  Data from square 1 is carried 0 steps, since it's at the access port.
  Data from square 12 is carried 3 steps, such as: down, left, left.
  Data from square 23 is carried only 2 steps: up twice.
  Data from square 1024 must be carried 31 steps.

"""

defmodule GridGenerator do
  @moduledoc """
    L - left; R - right
    U - up; D - down
    Formula:
      1 -> (R U L) -> (L D*D R*R) -> (R U*U*U L*L*L) -> ....
      Common: 1 -> (R U^C L^C) -> (L D^C R^C),
                where C   - array count of elements,
                      ->  - next bunch of steps
                      R U L D - one step in certain direction
    Example of producing the spiral grid for 4:
      [1] |> move to right [1,2] |> up [[3], [1,2]] |> left [[4,3], [1,2]]

  """

  def produce(n) when n <= 0, do: []
  def produce(1), do: [%{:row => 0, :col => 0, :value => 1}]
  def produce(input_number) when is_integer(input_number) do
    # init
    list_of_numbers = Enum.to_list 2..input_number
    grid = produce(1)
    steps = []
    # get list of steps for the total count of numbers
    generate_grid(grid, list_of_numbers, steps)
  end

  defp generate_grid(grid, [], _), do: grid
  defp generate_grid(grid, numbers, []) do # generate steps fro next iteration
    # get steps for iteration
    iteration_number = trunc(grid |> length() |> :math.sqrt())
    steps = get_steps(iteration_number)
    # iterate
    generate_grid(grid, numbers, steps)
  end
  defp generate_grid(grid, [num | numbers], [direction | steps]) do
    # get last added value
    [last | _] = grid
    # add new value
    new_value = case direction do
      :up -> %{:row => last.row - 1, :col => last.col, :value => num}
      :down -> %{:row => last.row + 1, :col => last.col, :value => num}
      :right -> %{:row => last.row, :col => last.col + 1, :value => num}
      :left -> %{:row => last.row, :col => last.col - 1, :value => num}
    end
    # iterate to the next number
    generate_grid([new_value | grid], numbers, steps)
  end

  defp get_steps(count) when rem(count, 2) != 0 do # odd starts eitht right
    # get list of steps
    ups = List.duplicate(:up, count)
    lefts = List.duplicate(:left, count)
    # generate result
    List.flatten([:right, ups, lefts])
  end
  defp get_steps(count) when rem(count, 2) == 0 do # even starts with left
    # get list of steps
    downs = List.duplicate(:down, count)
    rights = List.duplicate(:right, count)
    # generate result
    List.flatten([:left, downs, rights])
  end
end

defmodule StepsCounter do
  def calculate(number) when number <= 1, do: 0
  def calculate(number) do
    # produce grid
    grid = GridGenerator.produce(number)
    # iterate until found 1
    [last | _] = grid
    start_position = %{:row => last.row, :col => last.col}
    iterate(start_position, grid, 0)
  end

  defp iterate(%{:row => 0, :col => 0}, _, acc), do: acc # found 1 position. Acc = steps count
  defp iterate(position, grid, acc) do
    # get neareast values
    first = grid |> Enum.find(fn x -> x.row == get_next_index(position.row) and x.col == position.col end)
    second = grid |> Enum.find(fn x -> x.row == position.row and x.col == get_next_index(position.col) end)
    # compare each one is smallest. This is the next position
    next = compare_positions(first, second)
    # next step
    iterate(%{:row => next.row, :col => next.col}, grid, acc + 1)
  end

  defp get_next_index(index) when index == 0, do: 0
  defp get_next_index(index) when index < 0, do: index + 1
  defp get_next_index(index) when index > 0, do: index - 1

  defp compare_positions(a, b) do
    IO.inspect binding()
    cond do
      a == nil -> b
      b == nil -> a
      a.value <= b.value -> a
      a.value > b.value -> b
    end
  end
end

#StepsCounter.calculate(325489)|> IO.inspect()
