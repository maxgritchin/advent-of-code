_="""
  https://adventofcode.com/2017/day/9
"""
defmodule Groups do
  @ignore_regex ~r/(!.)/
  @find_garbage ~r/<.*?>/

  @doc """
  Claculates the score value for groups in a string

  ## Examples

      iex>Groups.score!("{{}}")
      3
  """
  def score!(data) do
    data
    #|> IO.inspect(label: "Data ")
    |> remove_garbage!()
    |> String.graphemes()
    #|> IO.inspect(label: "Parsed ")
    |> score(0, {0, 0})
  end
  defp score([], _, state), do: state
  defp score(["{" | rest], level, state) do
    score(rest, level + 1, state)
  end
  defp score(["}" | rest], level, {total, group_counts}) do
    score(rest, level - 1, {total + level, group_counts + 1})
  end
  defp score([ch | rest], level, state), do: score(rest, level, state)

  @doc """
  Calculate count of groups in the given string

  ## Examples

  """
  def count!(data) do
    {_, groups_count} = data |> score!()
    groups_count
  end

  @doc """
  Remove garbage from the string

  ## Examples
      iex>Groups.remove_garbage!("{<ds!>ds>}")
      {}

  """
  def remove_garbage!(data) do
    data
    |> remove_ignored_chars()
    |> remove_garbage_chars()
  end

  @doc """
  Calculation of the grabage characters count in the given string

  ## Examples
      iex>Groups.calc_garbage_chars!("<ab>")
      2

  """
  def calc_garbage_chars!(data) do
    data
    |> remove_ignored_chars()
    |> calc_garbage_chars()
  end

  defp remove_ignored_chars(data) do
    data |> String.replace(@ignore_regex, "")
  end
  defp remove_garbage_chars(data) do
    data |> String.replace(@find_garbage, "")
  end
  defp calc_garbage_chars(data) do
    Regex.scan(@find_garbage, data)
    |> List.flatten()
    |> Enum.reduce(0, fn x, acc -> acc + String.length(x) - 2 end)
  end
end

# TESTS
ExUnit.start

defmodule UnitTests do
  use ExUnit.Case
  #@doctest Groups

  test "remove garbage from the given string" do
    assert Groups.remove_garbage!("<>") == ""
    assert Groups.remove_garbage!("<sdfsdfsf>") == ""
    assert Groups.remove_garbage!("<!>>") == ""
    assert Groups.remove_garbage!("1<sdfsdfs<sdfsdf>2") == "12"
  end

  test "gets number of groups" do
    assert Groups.count!("{}") == 1
    assert Groups.count!("{{{}}}") == 3
    assert Groups.count!("{{},{}}") == 3
    assert Groups.count!("{{{},{},{{}}}}") == 6
    assert Groups.count!("{<{},{},{{}}>}") == 1
    assert Groups.count!("{<a>,<a>,<a>,<a>}") == 1
    assert Groups.count!("{{<a>},{<a>},{<a>},{<a>}}") == 5
    assert Groups.count!("{{<!>},{<!>},{<!>},{<a>}}") == 2
  end

  test "gets total score of groups" do
    assert Groups.score!("{}") == {1, 1}
    assert Groups.score!("{{{}}}") == {6, 3}
    assert Groups.score!("{{},{}}") == {5, 3}
    assert Groups.score!("{{{},{},{{}}}}") == {16, 6}
    assert Groups.score!("{<a>,<a>,<a>,<a>}") == {1, 1}
    assert Groups.score!("{{<ab>},{<ab>},{<ab>},{<ab>}}") == {9, 5}
    assert Groups.score!("{{<!!>},{<!!>},{<!!>},{<!!>}}") == {9, 5}
    assert Groups.score!("{{<a!>},{<a!>},{<a!>},{<ab>}}") == {3, 2}
  end

  test "gets count of the garbage chars" do
    assert Groups.calc_garbage_chars!("<>") == 0
    assert Groups.calc_garbage_chars!("<random characters>") == 17
    assert Groups.calc_garbage_chars!("<<<<>") == 3
    assert Groups.calc_garbage_chars!("<{!>}>") == 2
    assert Groups.calc_garbage_chars!("<!!>") == 0
    assert Groups.calc_garbage_chars!("<!!!>>") == 0
    assert Groups.calc_garbage_chars!("<{oi!a,<{i<a>") == 9
  end
end
