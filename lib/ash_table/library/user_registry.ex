defmodule AshTable.Users.Registry do
  use Ash.Registry

  entries do
    entry AshTable.User
  end
end
