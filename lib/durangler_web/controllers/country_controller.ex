defmodule DuranglerWeb.CountryController do
  @moduledoc """
    The CountryController is the primary interface used to
    manage and process CRUD http request for the Country data
    context.

    Refer to DuranglerWeb.Router.ex for additional information
    on URL route definitions to access this service.
  """
  use DuranglerWeb, :controller

  alias Durangler.Countries
  alias Durangler.Countries.Country

  action_fallback DuranglerWeb.FallbackController

  @doc """
    Returns a list of currently defined countries via an HTTP
    request to the controller.

    The `conn` argument contain the context of the current connection.

  ## Examples

      From the browser: localhost development, GET request
      
      localhost:4000/api/countries
  """
  def index(conn, _params) do
    countries = Countries.list_countries()
    render(conn, "index.json", countries: countries)
  end

  @doc """
    Creates a new `country` record and adds it to the database. Country
    records are uniquely added by the assigned three character country
    code. The request is rejected if the code is aleady defined in the 
    database.

    The `conn` argument contain the context of the current connection.

    The `country_params` contains the specific attributes for the country

    `Json Body Example`
        { 
            "country": {
              "code": "AUS",
              "name": "Australia",
              "currency_id": 1
            }
        }

  ## Examples

      From the browser: localhost development, POST request
      
      localhost:4000/api/countries
  """
  def create(conn, %{"country" => country_params}) do
    with {:ok, %Country{} = country} <- Countries.create_country(country_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.country_path(conn, :show, country))
      |> render("show.json", country: country)
    end
  end

  @doc """
    Retrieve a country record from the database using the specified id
    and renders the output for display. An indicator message will be
    generated if the requested id cannot be found.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the country record to retrieve

  ## Examples

      From the browser: localhost development, GET request
      
      <localhost:4000/api/countries/:id>
      localhost:4000/api/countries/12
  """
  def show(conn, %{"id" => id}) do
    case Countries.get_country(id) do
      nil -> {:error, :not_found}
      country -> render(conn, "show.json", country: country)
    end
  end
  
  @doc """
    Updates an existing country record in the database with the specified
    changes contained in the request.  The `body` of the json request 
    contains the updated values to apply.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the country record to update

    `Json Body Example`
        { 
            "country": {
                "name": "Australia"
            }
        }

  ## Examples

      From the browser: localhost development, PATCH request
      
      <localhost:4000/api/countries/:id>
      localhost:4000/api/countries/12
  """
  def update(conn, %{"id" => id, "country" => country_params}) do
    case Countries.get_country(id) do
      nil -> {:error, :not_found}
      country -> 
        with {:ok, %Country{} = country} 
          <- Countries.update_country(country, country_params) do
            render(conn, "show.json", country: country)
        end
    end
  end

  @doc """
    Deletes a country record from the database using the specified id.
    An indicator message will be generated if the requested id cannot be 
    found.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the country record to delete

  ## Examples

      From the browser: localhost development, DELETE request
      
      <localhost:4000/api/countries/:id>
      localhost:4000/api/countries/12
  """
  def delete(conn, %{"id" => id}) do
    case Countries.get_country(id) do
      nil -> {:error, :not_found}
      country ->
        with {:ok, %Country{}} 
          <- Countries.delete_country(country) do
            send_resp(conn, :no_content, "")
        end
    end
  end

end
