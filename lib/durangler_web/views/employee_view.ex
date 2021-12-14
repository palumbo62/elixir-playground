defmodule DuranglerWeb.EmployeeView do
  @moduledoc """
    The EmployeeView module is used to render JSON output for
    employee data.
  """ 
  use DuranglerWeb, :view
  alias DuranglerWeb.EmployeeView

  @doc """
    Used to render a list of employees in JSON format.
  """   
  def render("index.json", %{employees: employees}) do
    %{data: render_many(employees, EmployeeView, "employee.json")}
  end
   
  @doc """
    Used to render a single employee in JSON format.
  """
  def render("show.json", %{employee: employee}) do
    %{data: render_one(employee, EmployeeView, "employee.json")}
  end

  @doc """
    Used to render a single employee by `struct` in JSON format.
  """
  def render("employee.json", %{employee: employee}) do
    %{id: employee.id,
      first_name: employee.first_name,
      last_name: employee.last_name,
      emp_id: employee.emp_id,
      job_title: employee.job_title,
      salary: Decimal.round(employee.salary, 2),
      country_id: employee.country_id}
  end
end
