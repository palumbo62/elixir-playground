defmodule Durangler.Metrics do
  @moduledoc """
  The Metrics context which implement a set of helper
  functions used to interface to the attached database
  using the Repo module.  These functions define the
  queries used to obtains salary metrics based on either
  country or job title.
  """
  import Ecto.Query, warn: false
  alias Durangler.Repo

  @doc """
  Returns the list of salary_jobtitles.

  ## Examples

      iex> list_salary_jobtitles()
      [%SalaryJobtitle{}, ...]

  """
  def list_salary_jobtitles do
    q = from(e in "employees",
              join: c in "countries", 
              join: cr in "currencies",
              on: e.country_id == c.id,
              on: c.currency_id == cr.id,    
              select: %Durangler.Metrics.SalaryJobtitle{
                        jobtitle: e.job_title, 
                        avg: avg(e.salary), 
                        name: c.name, 
                        symbol: cr.symbol},
              group_by: [e.job_title, c.name, cr.symbol])

    Repo.all(q)
  end

  @doc """
  Gets a single salary_jobtitle.

  Raises `Ecto.NoResultsError` if the Salary jobtitle does not exist.

  ## Examples

      iex> get_salary_jobtitle!(123)
      %SalaryJobtitle{}

      iex> get_salary_jobtitle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_salary_by_jobtitle(id) do
    match_it = "%#{id}%"

    q = from(e in "employees",
            join: c in "countries", 
            join: cr in "currencies",
            on: e.country_id == c.id,
            on: c.currency_id == cr.id,  
            #where: e.job_title == ^id,  
            where: ilike(e.job_title, ^match_it),  
            select: %Durangler.Metrics.SalaryJobtitle{
                      jobtitle: e.job_title, 
                      avg: avg(e.salary), 
                      name: c.name, 
                      symbol: cr.symbol},
            group_by: [e.job_title, c.name, cr.symbol])

   Repo.all(q)
  end
  
  @doc """
  Returns the list of salary_countries.

  ## Examples

      iex> list_salary_countries()
      [%SalaryCountry{}, ...]

  """
  def list_salary_countries do
    q = from(e in "employees",
              join: c in "countries", 
              join: cr in "currencies",
              on: e.country_id == c.id,
              on: c.currency_id == cr.id,    
              select: %Durangler.Metrics.SalaryCountry{
                        code: c.code, 
                        crcode: cr.code, 
                        avg: avg(e.salary), 
                        min: min(e.salary), 
                        max: max(e.salary)},
              group_by: [c.code, cr.code])
    Repo.all(q)
  end

  @doc """
  Gets a single salary_country.

  Raises `Ecto.NoResultsError` if the Salary country does not exist.

  ## Examples

      iex> get_salary_country!(123)
      %SalaryCountry{}

      iex> get_salary_country!(456)
      ** (Ecto.NoResultsError)

  """
  def get_salary_by_country(id) do
    q = from(e in "employees",
              join: c in "countries", 
              join: cr in "currencies",
              on: e.country_id == c.id,
              on: c.currency_id == cr.id,    
              where: c.code == ^id,
              select: %Durangler.Metrics.SalaryCountry{
                        code: c.code, 
                        crcode: cr.code, 
                        avg: avg(e.salary), 
                        min: min(e.salary), 
                        max: max(e.salary)},
              group_by: [c.code, cr.code])
    Repo.all(q)
  end

end
