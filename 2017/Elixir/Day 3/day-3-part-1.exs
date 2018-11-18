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
  def produce(1), do: %{[0,0] => 1}
  def produce(input_number) when is_integer(input_number) do
    # init
    list_of_numbers = Enum.to_list 2..input_number
    grid = produce(1)
    steps = []
    start_position = [0,0]
    # get list of steps for the total count of numbers
    generate_grid(grid, list_of_numbers, steps, start_position)
  end

  defp generate_grid(grid, [], _, last), do: [grid, last]
  defp generate_grid(grid, numbers, [], last) do # generate steps fro next iteration
    # get steps for iteration
    iteration_number = trunc(Map.size(grid) |> :math.sqrt())
    steps = get_steps(iteration_number)
    # iterate
    generate_grid(grid, numbers, steps, last)
  end
  defp generate_grid(grid, [num | numbers], [direction | steps], last) do
    # get last added value
    [row, col] = last
    # add new value
    new_value = case direction do
      :up -> %{[row - 1, col] => num}
      :down -> %{[row + 1, col] => num}
      :right -> %{[row, col + 1] => num}
      :left -> %{[row, col - 1] => num}
    end
    # get calculated key
    [key | _] = new_value |> Map.keys()
    # iterate to the next number
    generate_grid(Map.merge(new_value, grid), numbers, steps, key)
  end

  defp get_steps(count) when rem(count, 2) != 0 do # odd starts with right
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
    [grid, start_position] = GridGenerator.produce(number)
    # iterate until found 1
    iterate(start_position, grid, 0)
  end

  defp iterate([0,0], _, acc), do: acc # found 1 position. Acc = steps count
  defp iterate(position, grid, acc) do
    [row, col] = position
    # compare each one is smallest. This is the next position
    next = compare(grid, [get_next_index(row), col], [row, get_next_index(col)])
    # next step
    iterate(next, grid, acc + 1)
  end

  defp get_next_index(index) when index == 0, do: 0
  defp get_next_index(index) when index < 0, do: index + 1
  defp get_next_index(index) when index > 0, do: index - 1

  defp compare(grid, a, b) do
    cond do
      grid[a] == nil -> b
      grid[b] == nil -> a
      grid[a] <= grid[b] -> a
      grid[a] > grid[b] -> b
    end
  end
end

#GridGenerator.produce(23) |> IO.inspect()
StepsCounter.calculate(325489)|> IO.inspect()
