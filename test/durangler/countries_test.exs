defmodule Durangler.CountriesTest do
  @moduledoc """
    The CountriesTest module is used to test the Countries and 
    Currencies contexts by executing a defined set of function 
    which exercise the CRUD functionality for both.
  """   
  use Durangler.DataCase

  alias Durangler.Countries

  describe "currencies" do
    alias Durangler.Countries.Currency

    @curr_valid_attrs %{
      code: "ABC", 
      name: "some name", 
      symbol: "#"}
    @curr_update_attrs %{
      code: "DEF",
      name: "some updated name",
      symbol: "$"
    }
    @curr_invalid_attrs %{code: nil, name: nil, symbol: nil}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@curr_valid_attrs)
        |> Countries.create_currency()

      currency
    end

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert Countries.list_currencies() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Countries.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      assert {:ok, %Currency{} = currency} = Countries.create_currency(@curr_valid_attrs)
      assert currency.code == "ABC"
      assert currency.name == "some name"
      assert currency.symbol == "#"
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Countries.create_currency(@curr_invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = Countries.update_currency(currency, @curr_update_attrs)
      assert currency.code == "DEF"
      assert currency.name == "some updated name"
      assert currency.symbol == "$"
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = Countries.update_currency(currency, @curr_invalid_attrs)
      assert currency == Countries.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = Countries.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Countries.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = Countries.change_currency(currency)
    end
  end

  describe "countries" do
    alias Durangler.Countries.Country

    @valid_attrs %{
      code: "ABC", 
      name: "some name",
      currency_id: 1
    }
    @update_attrs %{
      code: "DEF", 
      name: "some updated name",
    }
    @invalid_attrs %{
      code: nil, 
      name: nil,
    }

    def country_fixture(_attrs \\ %{}) do
      currency = currency_fixture()
      attrs = Map.put(@valid_attrs, :currency_id, currency.id)

      {:ok, country} =
        attrs
        |> Countries.create_country()
      country
    end

    test "list_countries/0 returns all countries" do
      country = country_fixture()
      assert Countries.list_countries() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Countries.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      country = country_fixture()
      assert country.code == "ABC"
      assert country.name == "some name"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Countries.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, %Country{} = country} = Countries.update_country(country, @update_attrs)
      assert country.code == "DEF"
      assert country.name == "some updated name"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Countries.update_country(country, @invalid_attrs)
      assert country == Countries.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Countries.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Countries.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Countries.change_country(country)
    end
  end
end
