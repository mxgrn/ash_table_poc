defmodule AshTable.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AshTable.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        birthdate: ~D[2024-01-01],
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> AshTable.Users.create_user()

    user
  end
end
