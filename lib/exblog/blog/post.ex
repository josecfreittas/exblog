defmodule Exblog.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exblog.Users.User

  schema "posts" do
    field :content, :string
    field :title, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :user_id])
    |> validate_required([:title, :content])
  end
end
