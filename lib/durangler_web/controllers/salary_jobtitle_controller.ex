defmodule DuranglerWeb.SalaryJobtitleController do
  @moduledoc """
    The SalaryJobtitleController is the primary interface used to
    manage and process query requests for Salary data based
    on job titles. 

    Refer to DuranglerWeb.Router.ex for additional information
    on URL route definitions to access this service.
  """
  use DuranglerWeb, :controller

  alias Durangler.Metrics

  action_fallback DuranglerWeb.FallbackController

  @doc """
    Returns a list of the average salary for all currently defined job titles.  
    The results are broken down by average salary by job title and currency given
    different countries have different currencies.

    The `conn` argument contain the context of the current connection.

  ## Examples

      From the browser: localhost development, GET request

      localhost:4000/metrics/salary_jobtitles
  """
  def index(conn, _params) do
    salary_jobtitles = Metrics.list_salary_jobtitles()
    render(conn, "index.json", salary_jobtitles: salary_jobtitles)
  end

  @doc """
    Returns a the average salary for a given job title using the specified
    job title. The results are broken down by average salary by job title 
    and currency given different countries have different currencies.

    The `conn` argument contain the context of the current connection.

   ## Examples

      From the browser: localhost development, GET request
      
      <localhost:4000/metrics/salary_countries/:id>
      localhost:4000/metrics/salary_countries/12
  """
  def show(conn, %{"id" => id}) do
    salary_jobtitle = Metrics.get_salary_by_jobtitle(id)
    render(conn, "show.json", salary_jobtitle: salary_jobtitle)
  end
end
