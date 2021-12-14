defmodule DuranglerWeb.SalaryJobtitleControllerTest do
  @moduledoc """
    The SalaryJobtitleControllerTest module is used to test the 
    SalaryJobtitle context by executing a defined set of function 
    which exercise the CRUD functionality for both.
  """     
  use DuranglerWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all salary_jobtitles", %{conn: conn} do
      conn = get(conn, Routes.salary_jobtitle_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
