_= """
In the same allocation order(in part 1), they store the sum of the values in all adjacent squares, including diagonals.

https://adventofcode.com/2017/day/3

## Example

Square 1 starts with the value 1.
Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.

147  142  133  122   59
304    5    4    2   57
330   10    1    1   54
351   11   23   25   26
362  747  806--->   ...

## Task

What is the first value written that is larger than your puzzle input?

## Input

325489
"""
defmodule Params do
  defstruct grid: %{{0,0} => 1}, point: {0,0}, steps: []
end

defmodule Calculator do
  def get_first_value_that_larger_than(number) when number <= 0, do: 1
  def get_first_value_that_larger_than(number) do
    # init
    params = %Params{}
    # calculation
    calculate(params, number, 0)
  end

  defp calculate(_, number, current_value) when current_value > number, do: current_value
  defp calculate(%Params{steps: []} = params, number, current_value) do # need calculate a bunch of steps
    iteration_number = trunc(Map.size(params.grid) |> :math.sqrt())
    params
    |> Map.put(:steps, get_steps(iteration_number))
    |> calculate(number, current_value)
  end
  defp calculate(params, number, _) do
    # get values
    [direction | steps] = params.steps
    # calculation
    {new_point, new_value} = calc_next_value(params.grid, params.point, direction)
    calculate(%Params{grid: Map.put(params.grid, new_point, new_value), point: new_point, steps: steps}, number, new_value)
  end

  defp calc_next_value(grid, point, direction) do
    # extract
    {r, c} = point
    # move point
    new_point =
      case direction do
        :up -> {r - 1, c}
        :down -> {r + 1, c}
        :right -> {r, c + 1}
        :left -> {r, c - 1}
      end
    # get value
    {row, col} = new_point
    new_value =
      # check list
      [ {row + 1, col}, # down
        {row + 1, col - 1}, # cross-down-left
        {row, col - 1}, # left
        {row - 1, col - 1}, # cross-up-left
        {row - 1, col}, # up
        {row - 1, col + 1}, # cross-up-right
        {row, col + 1}, # right
        {row + 1, col + 1}, # cross-down-right
      ]
      |> Enum.map(fn p -> grid[p] end)
      |> Enum.filter(fn x -> x != nil end)
      |> Enum.sum()
    # calculate
    {new_point, new_value}
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

Calculator.get_first_value_that_larger_than(325489) |> IO.inspect()
