defmodule DuranglerWeb.CountryControllerTest do
  @moduledoc """
    The CountryControllerTest module is used to test the Countries 
    context by executing a defined set of function which exercise
    the CRUD functionality for both.
  """   
  use DuranglerWeb.ConnCase

  alias Durangler.Countries
  alias Durangler.Countries.Country

  @cntry_valid_attrs %{
    code: "ABC",
    name: "some name",
    currency_id: 1
  }
  @cntry_update_attrs %{
    code: "DEF",
    name: "some updated name",
  }
  @invalid_attrs %{code: nil, name: nil}
  
  @curr_valid_attrs %{
    code: "ABC", 
    name: "some name", 
    symbol: "#"}

  def fixture(:country) do
    {:ok, currency} = Countries.create_currency(@curr_valid_attrs)
    attrs = Map.put(@cntry_valid_attrs, :currency_id, currency.id)

    {:ok, country} = Countries.create_country(attrs)

    country
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all countries", %{conn: conn} do
      conn = get(conn, Routes.country_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create country" do
    test "renders country when data is valid", %{conn: conn} do
      {:ok, currency} = Countries.create_currency(@curr_valid_attrs)
      attrs = Map.put(@cntry_valid_attrs, :currency_id, currency.id)

      conn = post(conn, Routes.country_path(conn, :create), country: attrs)
      assert %{"id" => id, "name" => name, "code" => code, 
               "currency_id" => currency_id} = json_response(conn, 201)["data"]

      assert code == "ABC"
      assert name == "some name"
      assert currency_id == currency.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.country_path(conn, :create), country: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update country" do
    setup [:create_country]

    test "renders country when data is valid", %{conn: conn, country: %Country{id: id} = country} do
      conn = put(conn, Routes.country_path(conn, :update, country), country: @cntry_update_attrs)
      assert %{"name" => name, "code" => code,
               "currency_id" => currency_id} = json_response(conn, 200)["data"]

      assert code == "DEF"
      assert name == "some updated name"
      assert currency_id == country.currency_id
    end

    test "renders errors when data is invalid", %{conn: conn, country: country} do
      conn = put(conn, Routes.country_path(conn, :update, country), country: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete country" do
    setup [:create_country]

    test "deletes chosen country", %{conn: conn, country: country} do
      conn = delete(conn, Routes.country_path(conn, :delete, country))
      assert response(conn, 204)

      data = get(conn, Routes.country_path(conn, :show, country))
      assert country.id == String.to_integer(data.params["id"])
    end
  end

  defp create_country(_) do
    country = fixture(:country)
    %{country: country}
  end
end
