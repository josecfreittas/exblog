defmodule ExblogWeb.Auth do
  use Joken.Config

  @one_week (60 * 60 * 24 * 7)

  def token_config, do: default_claims(default_exp: @one_week)

  def generate_access(user_email) do
      extra_clains = %{"user_email" => user_email}
      generate_and_sign(extra_clains)
  end
end
