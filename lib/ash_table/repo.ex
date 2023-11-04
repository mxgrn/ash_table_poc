defmodule AshTable.Repo do
  use AshPostgres.Repo,
    otp_app: :ash_table
end
