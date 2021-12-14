defmodule DuranglerWeb.CountryView do
  @moduledoc """
    The CountryView module is used to render JSON output for
    country data.
  """
  use DuranglerWeb, :view
  alias DuranglerWeb.CountryView

  @doc """
    Used to render a list of countries in JSON format.
  """
  def render("index.json", %{countries: countries}) do
    %{data: render_many(countries, CountryView, "country.json")}
  end

  @doc """
    Used to render a single country in JSON format.
  """
  def render("show.json", %{country: country}) do
    %{data: render_one(country, CountryView, "country.json")}
  end

  @doc """
    Used to render a single country by `struct` in JSON format.
  """
  def render("country.json", %{country: country}) do
    %{id: country.id, 
      currency_id: country.currency_id, 
      name: country.name, 
      code: country.code}
  end
end
