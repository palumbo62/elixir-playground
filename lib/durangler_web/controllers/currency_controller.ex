defmodule DuranglerWeb.CurrencyController do
  @moduledoc """
    The CurrencyController is the primary interface used to
    manage and process CRUD http request for the Currency data
    context.

    Refer to DuranglerWeb.Router.ex for additional information
    on URL route definitions to access this service.
  """
  use DuranglerWeb, :controller

  alias Durangler.Countries
  alias Durangler.Countries.Currency

  action_fallback DuranglerWeb.FallbackController

  @doc """
    Returns a list of currently defined currencies via an HTTP
    request to the controller.

    The `conn` argument contain the context of the current connection.

  ## Examples

      From the browser: localhost development, GET request
      
      localhost:4000/api/currencies
  """
   def index(conn, _params) do
    currencies = Countries.list_currencies()
    render(conn, "index.json", currencies: currencies)
  end

 @doc """
    Creates a new `currency` record and adds it to the database. Currency
    records are uniquely added by the assigned three character currency
    code. The request is rejected if the code is aleady defined in the 
    database.

    The `conn` argument contain the context of the current connection.

    The `currency_params` contains the specific attributes for the currency.

    `Json Body Example`
        { 
            "currency": {
                "code": "AUD",
                "name": "Australian Dollar",
                "symbol": "$"
            }
        }

  ## Examples

      From the browser: localhost development, POST request
      
      localhost:4000/api/currencies
  """
  def create(conn, %{"currency" => currency_params}) do
    with {:ok, %Currency{} = currency} <- Countries.create_currency(currency_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.currency_path(conn, :show, currency))
      |> render("show.json", currency: currency)
    end
  end

  @doc """
    Retrieve a currency record from the database using the specified id
    and renders the output for display. An indicator message will be
    generated if the requested id cannot be found.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the currency record to retrieve

  ## Examples

      From the browser: localhost development, GET request
      
      <localhost:4000/api/currencies/:id>
      localhost:4000/api/currencies/12
  """
  def show(conn, %{"id" => id}) do
    case Countries.get_currency(id) do
      nil -> {:error, :not_found}
      currency -> 
        render(conn, "show.json", currency: currency)
    end
  end

  @doc """
    Updates an existing currency record in the database with the specified
    changes contained in the request.  The `body` of the json request 
    contains the updated values to apply.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the currency record to update

    `Json Body Example`
        { 
            "country": {
                "name": "Australian Dollar"
            }
        }

  ## Examples

      From the browser: localhost development, PATCH request
      
      <localhost:4000/api/currencies/:id>
      localhost:4000/api/currencies/12
  """
  def update(conn, %{"id" => id, "currency" => currency_params}) do
    case Countries.get_currency(id) do
      nil -> {:error, :not_found}
      currency ->
        with {:ok, %Currency{} = currency} 
          <- Countries.update_currency(currency, currency_params) do
          render(conn, "show.json", currency: currency)
        end
    end
  end

  @doc """
    Deletes a currency record from the database using the specified id.
    An indicator message will be generated if the requested id cannot be 
    found.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the currency record to delete

  ## Examples

      From the browser: localhost development, DELETE request
      
      <localhost:4000/api/currencies/:id>
      localhost:4000/api/currencies/12
  """

  def delete(conn, %{"id" => id}) do
    case Countries.get_currency(id) do
      nil -> {:error, :not_found}
      currency ->
        with {:ok, %Currency{}} 
          <- Countries.delete_currency(currency) do
            send_resp(conn, :no_content, "")
        end
    end
  end

end 
