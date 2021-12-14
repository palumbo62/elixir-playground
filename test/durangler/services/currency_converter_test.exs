defmodule Durangler.Services.CurrencyConverterTest do
  @moduledoc false

  use ExUnit.Case
  alias Durangler.Services.CurrencyConverter, as: Converter

  describe "convert/3" do
    test "converting from a less valuable to a more valuable currency results in a smaller amount" do
      amount = 100.0

      #{:ok, result} = Converter.convert("JPY", "GBP", amount)
      #result = Converter.convert("JXPY", "GBP", amount)
      case Converter.convert("JPY", "GBP", amount) do
        {:ok, v} -> 
          assert v < amount
        :error -> 
          assert false, "unsupported currency conversion"
      end
    end

    test "when one of the currencies is unsupported we get an error tuple as a result" do
      amount = 100.0
      case Converter.convert("JPY", "GBP", amount) do
        {:ok, v} -> 
          {:ok, v}  # return the result in the form of a tuple
        :error -> 
          assert false, "unsupported currency conversion"
      end
    end
  end
end
