# Module for populating the database with randomized
# employee data. You can run it as:
#
#     $elixir run priv/repo/seeds_employee_data.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Durangler.Repo.insert!(%Durangler.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
defmodule EmployeeData do
  alias Durangler.Countries

  # Function to generate the first_names file and build a list first names
  def generate_first_names do
    with {:ok, first_names} = File.read("./priv/data/first_names.txt") do 
        first_names
        |> String.split("\r\n", trim: true) 
        #|> IO.inspect
    end
  end

  # Function to generate the last_names file and build a list last names
  def generate_last_names do
     with {:ok, last_names} = File.read("./priv/data/last_names.txt") do 
      last_names
      |> String.split("\r\n", trim: true) 
      #|> IO.inspect
    end
  end

  # Function to generate the job_title file and build a list of 100 random job titles
  def generate_job_titles do
    with {:ok, job_titles} = File.read("./priv/data/job_titles.txt") do 
      job_titles
      |> String.split("\r\n", trim: true) 
      |> Enum.shuffle()
      |> Enum.slice(%Range{first: 1, last: 100, step: 1})
      |> IO.inspect
    end
  end

  # Function to generate country and currencies to build a list of country and 
  # currency ids
  def generate_countries_currencies do
    # Get the countries list from the DB
    countries = Countries.list_countries()
          
    # Extract just the country and currency ids
    for c <- countries do
      [c.id]
    end
  end

  # Recursive function pair used to create the employee data set which will
  # populate the database with employee records.
  def create_emp_dataset(emp_dataset, fnms, lnms, jts, cdta, n) when n <= 1 do
    [ctryid] = Enum.random(cdta)
    
    employee =  %{country_id: ctryid, 
                  first_name: Enum.random(fnms), 
                  last_name: Enum.random(lnms), 
                  emp_id: n,
                  job_title: Enum.random(jts), 
                  salary: Enum.random(20000..125000)}

    MapSet.put(emp_dataset, employee)
  end

  def create_emp_dataset(emp_dataset, fnms, lnms, jts, cdta, n) do
    [ctryid] = Enum.random(cdta)
    
    employee =  %{country_id: ctryid, 
                  first_name: Enum.random(fnms), 
                  last_name: Enum.random(lnms),
                  emp_id: n, 
                  job_title: Enum.random(jts), 
                  salary: Enum.random(20000..125000)}

    emp_dataset = MapSet.put(emp_dataset, employee)
    create_emp_dataset(emp_dataset, fnms, lnms, jts, cdta, n - 1)
  end

  # Function to generate the 10000 employee records to populate the database
  def generate_employee_data(emp_dataset, n) do
    first_names = EmployeeData.generate_first_names
    last_names = EmployeeData.generate_last_names
    job_titles = EmployeeData.generate_job_titles
    country_data = EmployeeData.generate_countries_currencies

    # Create 10,000 employee records by matching a first name to a last name,
    # a random job title, a salary, and country of citizens ship.  
    # For salary we will generate a range of 10,000 to 100,000 in non-descript values

    # Use a recusrive function to select random values from the lists of employee data
    # to generate unique employee records.  Use a MapSet to filter the duplicates
    create_emp_dataset(emp_dataset, first_names, last_names, job_titles, country_data, n)

  end
end

# Use a Map Set to maintain unique records before adding them to the DB
emp_dataset = MapSet.new()
emp_dataset = EmployeeData.generate_employee_data(emp_dataset, 10000)

# Add the individual employee records to the DB
for emp <- emp_dataset do
  IO.inspect(emp)
  # Check for duplicates, if none add - there are no unique keys
  Durangler.Employees.create_employee!(emp) 
end


