defmodule AshTable.Repo do
  use Ecto.Repo,
    otp_app: :ash_table,
    adapter: Ecto.Adapters.Postgres
end
