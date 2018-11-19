defmodule Part1Tests do
  use ExUnit.Case
  Code.require_file("part-2.exs")

  test "valid passphrase" do
    assert Analizer.has_anagrams?("a ab abc abd abf abj") == false
  end

  test "invalid passphrase" do
    assert Analizer.has_anagrams?("oiii ioii iioi iiio") == true
  end

  test "invalid - the letters from the third word can be rearranged to form the first word" do
    assert Analizer.has_anagrams?("abcde xyz ecdab") == true
  end
end
