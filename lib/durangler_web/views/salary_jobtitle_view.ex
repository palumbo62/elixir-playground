defmodule DuranglerWeb.SalaryJobtitleView do
  @moduledoc """
    The SalaryJobtitleView module is used to render JSON output for
    salary data by job title.
  """ 
  use DuranglerWeb, :view
  alias DuranglerWeb.SalaryJobtitleView

  @doc """
    Used to render a list of salary data by job title in JSON format.
  """   
  def render("index.json", %{salary_jobtitles: salary_jobtitles}) do
    %{data: render_many(salary_jobtitles, SalaryJobtitleView, "salary_jobtitle.json")}
  end

  @doc """
    Used to render a single salary data by job title in JSON format.
  """
  def render("show.json", %{salary_jobtitle: salary_jobtitle}) do
    %{data: render_many(salary_jobtitle, SalaryJobtitleView, "salary_jobtitle.json")}
  end

  @doc """
    Used to render a single salary data by job title by `struct` in JSON format.
  """
  def render("salary_jobtitle.json", %{salary_jobtitle: salary_jobtitle}) do
    %{jobtitle: salary_jobtitle.jobtitle,
      avg: Decimal.round(salary_jobtitle.avg, 2),
      name: salary_jobtitle.name,
      symbol: salary_jobtitle.symbol}
  end
end
