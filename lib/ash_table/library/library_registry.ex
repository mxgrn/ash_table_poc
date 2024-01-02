defmodule AshTable.Library.Registry do
  use Ash.Registry

  entries do
    entry AshTable.Book
    entry AshTable.User
  end
end
