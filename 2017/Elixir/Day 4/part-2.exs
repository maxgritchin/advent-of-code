_="""
For added security, yet another system policy has been put in place. Now, a valid passphrase must contain no two words that are anagrams of each other - that is, a passphrase is invalid if any word's letters can be rearranged to form any other word in the passphrase.

## Example

abcde fghij is a valid passphrase.
abcde xyz ecdab is not valid - the letters from the third word can be rearranged to form the first word.
a ab abc abd abf abj is a valid passphrase, because all letters need to be used when forming another word.
iiii oiii ooii oooi oooo is valid.
oiii ioii iioi iiio is not valid - any of these words can be rearranged to form any other word.

## Task

Under this new system policy, how many passphrases are valid?
"""
defmodule Analizer do
  @moduledoc """
  Phrases analizer

  ## Overview

  This module has methods to anilize if any pahrases have anagrams.
  The approach includes the passphrase iteration (by word) and check if the word already has been met.

  ## Example

  abcde fghij is valid.
  oiii ioii iioi iiio is not valid - the word aa appears more than once.

  """

  def has_anagrams?(phrase) when is_bitstring(phrase) do
    anagrams? = fn phrase, map, fun ->
      cond do
        phrase == [] -> false
        true ->
          [word | rest] = phrase
          sorted_word = word |> String.to_charlist() |> Enum.sort() |> to_string()
          cond do
            map |> MapSet.member?(sorted_word) -> true
            true -> fun.(rest, MapSet.put(map, sorted_word), fun)
          end
      end
    end

    phrase
    #|> IO.inspect(label: "Input phraze ")
    |> String.split(" ")
    |> anagrams?.(MapSet.new(), anagrams?)
    #|> IO.inspect(label: "Has anagrams ")
  end
end

File.read!("passphrases.dat")
|> String.split("\n")
|> Enum.filter(fn p -> Analizer.has_anagrams?(p) == false end)
|> length
|> IO.inspect(label: "Count of valid passphrases ")


