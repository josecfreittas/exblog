defmodule Exblog.UsersTest do
  use Exblog.DataCase

  alias Exblog.Users

  describe "users" do
    alias Exblog.Users.User

    import Exblog.UsersFixtures

    @invalid_attrs %{display_name: nil, email: nil, image: nil, password: nil}
    @valid_attrs %{
      "display_name" => "Brett Wiltshire",
      "email" => "brett@email.com",
      "image" => "https://i.imgur.com/uSEgddG.png",
      "password" => "123456"
    }

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user(:id, user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.display_name == "Brett Wiltshire"
      assert user.email == "brett@email.com"
      assert user.image == "https://i.imgur.com/uSEgddG.png"
    end

    test "create_user/1 with a invalid display_name" do
      attrs = %{@valid_attrs | "password" => "jota"}
      assert {:error, %Ecto.Changeset{}} = Users.create_user(attrs)
    end

    test "create_user/1 with a invalid password" do
      attrs = %{@valid_attrs | "password" => "123"}
      assert {:error, %Ecto.Changeset{}} = Users.create_user(attrs)
    end

    test "create_user/1 with no password" do
      attrs = Map.delete(@valid_attrs, "password")
      assert {:error, %Ecto.Changeset{}} = Users.create_user(attrs)
    end

    test "create_user/1 with invalid emails" do
      attrs_1 = %{@valid_attrs | "email" => "rubinho"}
      attrs_2 = %{@valid_attrs | "email" => "@gmail.com"}

      assert {:error, %Ecto.Changeset{}} = Users.create_user(attrs_1)
      assert {:error, %Ecto.Changeset{}} = Users.create_user(attrs_2)
    end

    test "create_user/1 with no email" do
      attrs = Map.delete(@valid_attrs, "email")
      assert {:error, %Ecto.Changeset{}} = Users.create_user(attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
