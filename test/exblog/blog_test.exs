defmodule Exblog.BlogTest do
  use Exblog.DataCase

  alias Exblog.Blog

  describe "posts" do
    alias Exblog.Blog.Post

    import Exblog.BlogFixtures

    @invalid_attrs %{content: nil, title: nil}
    @valid_attrs %{
      "content" => "some updated content",
      "title" => "some updated title"
    }

    test "list_posts/0 returns all posts" do
      post_fixture()
      assert length(Blog.list_posts(nil)) >= 1
    end

    test "get_post/1 returns the post with given id" do
      %{id: post_id} = post_fixture()
      assert %{id: ^post_id} = Blog.get_post(post_id)
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{content: "some content", title: "some title"}

      assert {:ok, %Post{} = post} = Blog.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "create_post/1 with no title" do
      attrs = Map.delete(@valid_attrs, "title")
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(attrs)
    end

    test "create_post/1 with no content" do
      attrs = Map.delete(@valid_attrs, "content")
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{content: "some updated content", title: "some updated title"}

      assert {:ok, %Post{} = post} = Blog.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      %{id: post_id} = post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert %{id: ^post_id} = Blog.get_post(post_id)
    end

    test "update_post/2 with no content" do
      %{id: post_id} = post = post_fixture()
      attrs = Map.delete(@valid_attrs, "content")
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, attrs)
      assert %{id: ^post_id} = Blog.get_post(post_id)
    end

    test "update_post/2 with no title" do
      %{id: post_id} = post = post_fixture()
      attrs = Map.delete(@valid_attrs, "title")
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, attrs)
      assert %{id: ^post_id} = Blog.get_post(post_id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
