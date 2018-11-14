_ = """
The goal is to find the only two numbers in each row where one evenly divides the other - that is, where the result of the division operation is a whole number. They would like you to find those numbers on each line, divide them, and add up each line's result.
"""

defmodule Calculator do

  @moduledoc """
    Calculator module for day 1 part 2

    ## Example

    5 9 2 8
    9 4 7 3
    3 8 6 5
    In the first row, the only two numbers that evenly divide are 8 and 2; the result of this division is 4.
    In the second row, the two numbers are 9 and 3; the result is 3.
    In the third row, the result is 2.
    In this example, the sum of the results would be 4 + 3 + 2 = 9.
  """
  def sum([], acc), do: acc
  def sum([row | rest], acc) do
    sum(rest, acc + find_in_row(row))
  end

  defp find_in_row([]), do: 0
  defp find_in_row([value | rest]) do
    {status, searched} = row_iterate(value, rest)
    cond do
      :found == status ->
        searched
      :not_found = status  ->
        find_in_row(rest) # next number
    end
  end

  defp row_iterate(_, []), do: {:not_found, 0}
  defp row_iterate(value, [next | rest]) do
    {searched_value, rem_value} = div_numbers(value, next)
    cond do
      rem_value == 0  ->
        {:found, searched_value}
      true ->
        row_iterate(value, rest)
    end
  end

  defp div_numbers(first, second) when first >= second, do: {div(first, second), rem(first, second)}
  defp div_numbers(first, second) when first < second, do: {div(second, first), rem(second, first)}
end

# Expected result is 9
test_input = "
5 9 2 8
9 4 7 3
3 8 6 5
"

test_input
|> String.trim()
|> String.split("\n")
|> Enum.map(fn row -> String.replace(row, "\t", " ") end)
|> Enum.map(fn row -> String.split(row, " ") end)
|> Enum.map(fn row -> Enum.map(row, fn v -> String.to_integer(v) end) end)
|> Calculator.sum(0)
|> IO.inspect()

# SOLVE THE TASK PART 2

test_input = "
1364	461	1438	1456	818	999	105	1065	314	99	1353	148	837	590	404	123
204	99	235	2281	2848	3307	1447	3848	3681	963	3525	525	288	278	3059	821
280	311	100	287	265	383	204	380	90	377	398	99	194	297	399	87
7698	2334	7693	218	7344	3887	3423	7287	7700	2447	7412	6147	231	1066	248	208
3740	837	4144	123	155	2494	1706	4150	183	4198	1221	4061	95	148	3460	550
1376	1462	73	968	95	1721	544	982	829	1868	1683	618	82	1660	83	1778
197	2295	5475	2886	2646	186	5925	237	3034	5897	1477	196	1778	3496	5041	3314
179	2949	3197	2745	1341	3128	1580	184	1026	147	2692	212	2487	2947	3547	1120
460	73	52	373	41	133	671	61	634	62	715	644	182	524	648	320
169	207	5529	4820	248	6210	255	6342	4366	5775	5472	3954	3791	1311	7074	5729
5965	7445	2317	196	1886	3638	266	6068	6179	6333	229	230	1791	6900	3108	5827
212	249	226	129	196	245	187	332	111	126	184	99	276	93	222	56
51	592	426	66	594	406	577	25	265	578	522	57	547	65	564	622
215	2092	1603	1001	940	2054	245	2685	206	1043	2808	208	194	2339	2028	2580
378	171	155	1100	184	937	792	1436	1734	179	1611	1349	647	1778	1723	1709
4463	4757	201	186	3812	2413	2085	4685	5294	5755	2898	200	5536	5226	1028	180
"

test_input
|> String.trim()
|> String.split("\n")
|> Enum.map(fn row -> String.replace(row, "\t", " ") end)
|> Enum.map(fn row -> String.split(row, " ") end)
|> Enum.map(fn row -> Enum.map(row, fn v -> String.to_integer(v) end) end)
|> Calculator.sum(0)
|> IO.inspect()
