defmodule AshTable.Library do
  use Ash.Api

  resources do
    registry AshTable.Library.Registry
  end
end
