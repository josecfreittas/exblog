defmodule ExblogWeb.PostControllerTest do
  use ExblogWeb.ConnCase

  import Exblog.BlogFixtures

  @create_attrs %{
    "content" => "some content",
    "title" => "some title"
  }
  @update_attrs %{
    "content" => "some updated content",
    "title" => "some updated title"
  }
  @invalid_attrs %{content: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag signed_in: "myloggeduser"
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "try to list all posts without an auth token", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert json_response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try to list all posts with an invalid auth token", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert json_response(conn, 401)
    end
  end

  describe "search posts" do
    @tag signed_in: "myloggeduser"
    test "search posts by title", %{conn: conn} do
      post_fixture(%{title: "my title"})
      conn = get(conn, Routes.post_path(conn, :index, q: "my title"))
      assert length(json_response(conn, 200)["data"]) == 1
    end

    @tag signed_in: "myloggeduser"
    test "search posts by content", %{conn: conn} do
      post_fixture(%{content: "my content"})
      conn = get(conn, Routes.post_path(conn, :index, q: "my content"))
      assert length(json_response(conn, 200)["data"]) == 1
    end

    @tag signed_in: "myloggeduser"
    test "search posts with no match", %{conn: conn} do
      post_fixture()
      conn = get(conn, Routes.post_path(conn, :index, q: "my unmatchable search"))
      assert length(json_response(conn, 200)["data"]) == 0
    end

    @tag signed_in: "myloggeduser"
    test "search posts with an empty query", %{conn: conn} do
      post_fixture()
      conn = get(conn, Routes.post_path(conn, :index, q: ""))
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "try to search posts without an auth token", %{conn: conn} do
      post_fixture()
      conn = get(conn, Routes.post_path(conn, :index, q: "my"))
      assert json_response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try search posts with an invalid auth token", %{conn: conn} do
      post_fixture()
      conn = get(conn, Routes.post_path(conn, :index, q: "my"))
      assert json_response(conn, 401)
    end
  end

  describe "get post" do
    @tag signed_in: "myloggeduser"
    test "get a post by id using a logged user", %{conn: conn} do
      post = post_fixture()

      conn = get(conn, Routes.post_path(conn, :show, post.id))
      assert json_response(conn, 200)["data"] != %{}
    end

    test "try to get a post by id without using logged user", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :show, 1))
      assert json_response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try to get a post by id with and invalid auth token", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :show, 1))
      assert json_response(conn, 401)
    end

    @tag signed_in: "myloggeduser"
    test "try to get an invalid post by id", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :show, 42))
      assert json_response(conn, 404)
    end
  end

  describe "create post" do
    @tag signed_in: "myloggeduser"
    test "renders post when data is valid", %{conn: conn, current_user: user} do
      conn = post(conn, Routes.post_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      user_id = user.id

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "content" => "some content",
               "title" => "some title",
               "user_id" => ^user_id
             } = json_response(conn, 200)["data"]
    end

    @tag signed_in: "myloggeduser"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "try to create a post without the auth token", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), @create_attrs)
      assert json_response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try to create a post with and invalid auth token", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), @create_attrs)
      assert json_response(conn, 401)
    end
  end

  describe "update post" do
    @tag signed_in: "myloggeduser"
    test "update a post", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = put(conn, Routes.post_path(conn, :update, id), @update_attrs)
      assert json_response(conn, 200)

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "content" => "some updated content",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    @tag signed_in: "myloggeduser"
    test "try to update a post from another user", %{conn: conn} do
      post = post_fixture()

      conn = put(conn, Routes.post_path(conn, :update, post.id), @update_attrs)
      assert json_response(conn, 401)
    end

    test "try to update a post without an auth token", %{conn: conn} do
      post = post_fixture()

      conn = put(conn, Routes.post_path(conn, :update, post.id), @update_attrs)
      assert json_response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try to update a post with an invalid auth token", %{conn: conn} do
      post = post_fixture()

      conn = put(conn, Routes.post_path(conn, :update, post.id), @update_attrs)
      assert json_response(conn, 401)
    end

    @tag signed_in: "myloggeduser"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = put(conn, Routes.post_path(conn, :update, id), @invalid_attrs)
      assert json_response(conn, 422)
    end
  end

  describe "delete post" do
    @tag signed_in: "myloggeduser"
    test "deletes chosen post", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = delete(conn, Routes.post_path(conn, :delete, id))
      assert response(conn, 204)
    end

    @tag signed_in: "myloggeduser"
    test "try to deletes an inexistent post", %{conn: conn} do
      conn = delete(conn, Routes.post_path(conn, :delete, 42))
      assert response(conn, 404)
    end

    @tag signed_in: "myloggeduser"
    test "try to deletes a post from another user", %{conn: conn} do
      post = post_fixture()

      conn = delete(conn, Routes.post_path(conn, :delete, post.id))
      assert response(conn, 401)
    end

    test "try to deletes a post without an auth token", %{conn: conn} do
      post = post_fixture()

      conn = delete(conn, Routes.post_path(conn, :delete, post.id))
      assert response(conn, 401)
    end

    @tag :invalid_auth_token
    test "try to deletes a post with an invalid auth token", %{conn: conn} do
      post = post_fixture()

      conn = delete(conn, Routes.post_path(conn, :delete, post.id))
      assert response(conn, 401)
    end
  end
end
