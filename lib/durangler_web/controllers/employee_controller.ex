defmodule DuranglerWeb.EmployeeController do
  @moduledoc """
    The EmployeeController is the primary interface used to
    manage and process CRUD http request for the Employee data
    context.

    Refer to DuranglerWeb.Router.ex for additional information
    on URL route definitions to access this service.
  """
  use DuranglerWeb, :controller

  alias Durangler.Employees
  alias Durangler.Employees.Employee

  action_fallback DuranglerWeb.FallbackController

  @doc """
    Returns a list of currently defined employees via an HTTP
    request to the controller.

    The `conn` argument contain the context of the current connection.

  ## Examples

      From the browser: localhost development, GET request
      
      localhost:4000/api/employees
  """
  def index(conn, _params) do
    employees = Employees.list_employees()
    render(conn, "index.json", employees: employees)
  end

  @doc """
    Creates a new `employee` record and adds it to the database. Employee
    records are uniquely added by assigned employee id.  The request is
    rejected if the id aleady defined in the database.

    The `conn` argument contain the context of the current connection.
    
    The `employee_params` contains the specific attributes for the employee.

    `Json Body Example`
        { 
            "employee": {
            "first_name": "Jimmie",
            "last_name": "Johns",
            "emp_id": 1000,
            "job_title": "High School CS/Eng Teacher",
            "salary": 55611.99,
            "country_id": 12
            }
        }

  ## Examples

      From the browser: localhost development, POST request
      
      localhost:4000/api/employees
  """
  def create(conn, %{"employee" => employee_params}) do
    with {:ok, %Employee{} = employee} <- Employees.create_employee(employee_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.employee_path(conn, :show, employee))
      |> render("show.json", employee: employee)
    end
  end

  @doc """
    Retrieve a country record from the database using the specified id
    and renders the output for display. An indicator message will be
    generated if the requested id cannot be found.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the employee record to retrieve

  ## Examples

      From the browser: localhost development, GET request
      
      <localhost:4000/api/employees/:id>
      localhost:4000/api/employees/12
  """
  def show(conn, %{"id" => id}) do
    case Employees.get_employee(id) do
      nil -> {:error, :not_found}
      employee ->
        render(conn, "show.json", employee: employee)
    end
  end

  @doc """
    Updates an existing employee record in the database with the specified
    changes contained in the request.  The `body` of the json request 
    contains the updated values to apply.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the employee record to update

    `Json Body Example`
        { 
            "employee": {
            "first_name": "James",
            "salary": 65000.00,
            }
        }

  ## Examples

      From the browser: localhost development, PATCH request
      
      <localhost:4000/api/employees/:id>
      localhost:4000/api/employees/12
  """
  def update(conn, %{"id" => id, "employee" => employee_params}) do
    case Employees.get_employee(id) do
      nil -> {:error, :not_found}
      employee ->
        with {:ok, %Employee{} = employee} 
          <- Employees.update_employee(employee, employee_params) do
            render(conn, "show.json", employee: employee)
        end
    end
  end


  @doc """
    Deletes an employee record from the database using the specified id.
    An indicator message will be generated if the requested id cannot be 
    found.
    
    The `conn` argument contain the context of the current connection.

    The `id` contains the identifier of the employee record to delete

  ## Examples

      From the browser: localhost development, DELETE request
      
      <localhost:4000/api/employees/:id>
      localhost:4000/api/employees/12
  """
  def delete(conn, %{"id" => id}) do
    case Employees.get_employee(id) do
      nil -> {:error, :not_found}
      employee ->
        with {:ok, %Employee{}} 
          <- Employees.delete_employee(employee) do
            send_resp(conn, :no_content, "")
        end
    end
  end

end
