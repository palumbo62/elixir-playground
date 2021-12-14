defmodule DuranglerWeb.CurrencyView do
  @moduledoc """
    The CurrencyView module is used to render JSON output for
    currency data.
  """
  use DuranglerWeb, :view
  alias DuranglerWeb.CurrencyView

  @doc """
    Used to render a list of currencies in JSON format.
  """ 
  def render("index.json", %{currencies: currencies}) do
    %{data: render_many(currencies, CurrencyView, "currency.json")}
  end
  
  @doc """
    Used to render a single currency in JSON format.
  """
  def render("show.json", %{currency: currency}) do
    %{data: render_one(currency, CurrencyView, "currency.json")}
  end

  @doc """
    Used to render a single currency by `struct` in JSON format.
  """
  def render("currency.json", %{currency: currency}) do
    %{id: currency.id, 
      code: currency.code, 
      name: currency.name, 
      symbol: currency.symbol}
  end
end
