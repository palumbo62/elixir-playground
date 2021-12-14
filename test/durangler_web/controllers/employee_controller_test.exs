defmodule DuranglerWeb.EmployeeControllerTest do
  @moduledoc """
    The EmployeeControllerTest module is used to test the Employees 
    context by executing a defined set of function which exercise
    the CRUD functionality for both.
  """   
  use DuranglerWeb.ConnCase

  alias Durangler.Employees
  alias Durangler.Employees.Employee
  alias Durangler.Countries
  alias Durangler.Countries.Country

  @cntry_valid_attrs %{
    code: "ABC", 
    name: "some name",
    currency_id: 1
  }

  @curr_valid_attrs %{
    code: "ABC", 
    name: "some name",
    symbol: "&",
  }

  @create_attrs %{
    country_id: 2,
    first_name: "some first_name",
    last_name: "some last_name",
    emp_id: 100,
    job_title: "some job_title",
    salary: 120.50
  }
  @update_attrs %{
    country_id: 3,
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    emp_id: 200,
    job_title: "some updated job_title",
    salary: 1456.70
  }
  @invalid_attrs %{
    country_id: nil, 
    first_name: nil, 
    last_name: nil, 
    emp_id: nil,
    job_title: nil, 
    salary: nil
  }

  def fixture(:employee) do
    # Because the employee is linked to a country and currency 
    # record in the DB, a new record for each type must be 
    # inserted into the DB before the employee can be added
    # to prevent contraint errors
    {:ok, currency} = Countries.create_currency(@curr_valid_attrs)
    attrs = Map.put(@cntry_valid_attrs, :currency_id, currency.id)

    {:ok, country} = Countries.create_country(attrs)
    attrs = Map.put(@create_attrs, :country_id, country.id)

    {:ok, employee} = Employees.create_employee(attrs)
    employee
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all employees", %{conn: conn} do
      conn = get(conn, Routes.employee_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create employee" do
    test "renders employee when data is valid", %{conn: conn} do
      {:ok, currency} = Countries.create_currency(@curr_valid_attrs)
      attrs = Map.put(@cntry_valid_attrs, :currency_id, currency.id)
      
      {:ok, country} = Countries.create_country(attrs)
      attrs = Map.put(@create_attrs, :country_id, country.id)
      
      conn = post(conn, Routes.employee_path(conn, :create), employee: attrs)
      assert %{"id" => id, "country_id" => country_id, "job_title" => job_title,
               "last_name" => last_name, "first_name" => first_name,
               "salary" => salary, "emp_id" => emp_id} = json_response(conn, 201)["data"]
     
      assert first_name == "some first_name"
      assert last_name == "some last_name"
      assert job_title == "some job_title"
      assert salary == "120.50"
      assert emp_id == 100
      assert country_id == country.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.employee_path(conn, :create), employee: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update employee" do
    setup [:create_employee]

    test "renders employee when data is valid", %{conn: conn, employee: %Employee{id: id} 
                                                  = employee} do
      # Update the country id to a valid country
      attrs = Map.put(@update_attrs, :country_id, employee.country_id)
      conn = put(conn, Routes.employee_path(conn, :update, employee), employee: attrs)

      assert %{"id" => id, "country_id" => country_id, "job_title" => job_title,
               "last_name" => last_name, "first_name" => first_name,
               "salary" => salary, "emp_id" => emp_id} = json_response(conn, 200)["data"]

      assert first_name == "some updated first_name"
      assert last_name == "some updated last_name"
      assert job_title == "some updated job_title"
      assert salary == "1456.70"
      assert emp_id == 200
      assert employee.country_id == country_id
    end

    test "renders errors when data is invalid", %{conn: conn, employee: employee} do
      conn = put(conn, Routes.employee_path(conn, :update, employee), employee: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete employee" do
    setup [:create_employee]

    test "deletes chosen employee", %{conn: conn, employee: employee} do
      conn = delete(conn, Routes.employee_path(conn, :delete, employee))
      assert response(conn, 204)
      
      data = get(conn, Routes.employee_path(conn, :show, employee))
      assert employee.id == String.to_integer(data.params["id"])
    end
  end

  defp create_employee(_) do
    employee = fixture(:employee)
    %{employee: employee}
  end
end