defmodule DuranglerWeb.SalaryCountryController do
  @moduledoc """
    The SalaryCountryController is the primary interface used to
    manage and process query requests for Salary data based
    on Country. 

    Refer to DuranglerWeb.Router.ex for additional information
    on URL route definitions to access this service.
  """
  use DuranglerWeb, :controller

  alias Durangler.Metrics

  action_fallback DuranglerWeb.FallbackController

  @doc """
    Returns a list salary statistics for all currently defined countries.  
    The statistics include minimum, maximum, and average salaries per 
    country/currency.

    The `conn` argument contain the context of the current connection.

  ## Examples

      From the browser: localhost development, GET request
      
      localhost:4000/metrics/salary_countries
  """
  def index(conn, _params) do
    salary_countries = Metrics.list_salary_countries()
    render(conn, "index.json", salary_countries: salary_countries)
  end

  @doc """
    Returns a the salary statistics for a given country using the specified
    country id. The statistics include minimum, maximum, and average salaries 
    per country/currency.

    The `conn` argument contain the context of the current connection.

   ## Examples

      From the browser: localhost development, GET request
      
      <localhost:4000/metrics/salary_countries/:id>
      localhost:4000/metrics/salary_countries/12
  """
  def show(conn, %{"id" => id}) do
    salary_country = Metrics.get_salary_by_country(id)
    render(conn, "show.json", salary_country: salary_country)
  end

end
