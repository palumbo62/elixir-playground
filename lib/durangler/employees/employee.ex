defmodule Durangler.Employees.Employee do
   @moduledoc """
    Defines the schema and changeset used to map 
    employee data between the application and the
    database, as well as, to validate the data
    against the specified changeset pipeline. 
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :country_id, :integer
    field :emp_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :job_title, :string
    field :salary, :decimal
   
    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:country_id, :emp_id,
                    :first_name, :last_name, 
                    :job_title, :salary])
    |> validate_required([:country_id, :emp_id,
                    :first_name, :last_name, 
                    :job_title, :salary])
    |> validate_number(:emp_id, greater_than: 0)
    |> validate_number(:salary, greater_than: 0)      
    |> validate_number(:country_id, greater_than: 0)  
    |> validate_length(:first_name, min: 1, max: 30)
    |> validate_length(:last_name, min: 1, max: 40)
    |> validate_length(:job_title, min: 1, max: 40)
    |> foreign_key_constraint(:country_id) 
    |> unique_constraint(:emp_id) 
  end
end
