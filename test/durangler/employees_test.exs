defmodule Durangler.EmployeesTest do
  @moduledoc """
    The EmployeesTest module is used to test the Employees 
    context by executing a defined set of function which 
    exercise the CRUD functionality for both.
  """   
  use Durangler.DataCase
 
  describe "employees" do
    alias Durangler.Employees
    alias Durangler.Employees.Employee
    alias Durangler.Countries

    @cntry_valid_attrs %{
      code: "ABC", 
      name: "some name",
      currency_id: 1
    }
    @curr_valid_attrs %{
      code: "DEF", 
      name: "some name", 
      symbol: "$"}
 
    @valid_attrs %{
      country_id: 1, 
      first_name: "some first_name", 
      last_name: "some last_name", 
      job_title: "some job_title", 
      salary: 120.50,
      emp_id: 100
    }

    @update_attrs %{
      country_id: 2, 
      first_name: "some updated first_name", 
      last_name: "some updated last_name", 
      job_title: "some updated job_title", 
      salary: 220.50,
      emp_id: 200
    }

    @invalid_attrs %{
      country_id: nil, 
      first_name: nil, 
      last_name: nil, 
      job_title: nil, 
      salary: nil,
      emp_id: nil
    }

    def employee_fixture(_attrs \\ %{}) do
      {:ok, currency} = Countries.create_currency(@curr_valid_attrs)
      attrs = Map.put(@cntry_valid_attrs, :currency_id, currency.id)

      {:ok, country} = Countries.create_country(attrs)
      attrs = Map.put(@valid_attrs, :country_id, country.id)

      {:ok, employee} = Employees.create_employee(attrs)

      employee  
    end

    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
      assert Employees.list_employees() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert Employees.get_employee!(employee.id) == employee
    end

    test "create_employee/1 with valid data creates a employee" do
      employee = employee_fixture()
      assert employee.first_name == "some first_name"
      assert employee.last_name == "some last_name"
      assert employee.job_title == "some job_title"
      assert Decimal.to_float(employee.salary) == 120.50
      assert employee.emp_id == 100
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      attrs = Map.put(@update_attrs, :country_id, employee.country_id)
      assert {:ok, %Employee{} = employee} = Employees.update_employee(employee, attrs)
      assert employee.first_name == "some updated first_name"
      assert employee.last_name == "some updated last_name"
      assert employee.job_title == "some updated job_title"
      assert Decimal.to_float(employee.salary) == 220.50
      assert employee.emp_id == 200      
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.update_employee(employee, @invalid_attrs)
      assert employee == Employees.get_employee(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Employees.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Employees.change_employee(employee)
    end
  end
end
