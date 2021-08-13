defmodule ExblogWeb.UserControllerTest do
  use ExblogWeb.ConnCase

  import Exblog.UsersFixtures

  @create_attrs %{
    "display_name" => "Brett Wiltshire",
    "email" => "brett@email.com",
    "password" => "123456",
    "image" => "https://i.imgur.com/uSEgddG.png"
  }
  @invalid_attrs %{
    "display_name" => nil,
    "email" => nil,
    "password" => nil,
    "image" => nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag signed_in: "myloggeduser"
    test "lists all users using a logged user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "try to lists all users without using a logged user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try to lists all users with a invalid login token", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 401)
    end
  end

  describe "get user" do
    @tag signed_in: "myloggeduser"
    test "get a user by id using a logged user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, 1))
      assert json_response(conn, 200)["data"] != %{}
    end

    test "try to get a user by id without using a logged user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, 1))
      assert json_response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try to get a user by id with a invalid login token", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, 1))
      assert json_response(conn, 401)
    end

    @tag signed_in: "myloggeduser"
    test "try to get a inexistent user by", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, 42))
      assert json_response(conn, 404)
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @create_attrs)
      assert %{"token" => _} = json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login user" do
    test "get auth token with valid credentials", %{conn: conn} do
      password = "1234567"
      user = user_fixture(%{"password" => password})

      conn =
        post(conn, Routes.user_path(conn, :login), %{
          "email" => user.email,
          "password" => password
        })

      assert %{"token" => _} = json_response(conn, 200)
    end

    test "get auth token with invalid email", %{conn: conn} do
      password = "1234567"
      user_fixture(%{"password" => password})

      conn =
        post(conn, Routes.user_path(conn, :login), %{
          "email" => "invalid@email.com",
          "password" => password
        })

      assert json_response(conn, 400)
    end

    test "get auth token with invalid password", %{conn: conn} do
      password = "1234567"
      user = user_fixture(%{"password" => password})

      conn =
        post(conn, Routes.user_path(conn, :login), %{
          "email" => user.email,
          "password" => "invalidpass"
        })

      assert json_response(conn, 400)
    end
  end

  describe "delete user" do
    @tag signed_in: "tobedeleteduser"
    test "deletes user", %{conn: conn} do
      conn = delete(conn, Routes.user_path(conn, :delete, "me"))
      assert response(conn, 204)
    end

    test "try to deletes user without auth token", %{conn: conn} do
      conn = delete(conn, Routes.user_path(conn, :delete, "me"))
      assert response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try to deletes user with an invalid auth token", %{conn: conn} do
      conn = delete(conn, Routes.user_path(conn, :delete, "me"))
      assert response(conn, 401)
    end
  end
end
