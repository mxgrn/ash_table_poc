defmodule AshTable.Library do
  use Ash.Api, extensions: [AshAdmin.Api]

  admin do
    show? true
  end

  resources do
    registry AshTable.Library.Registry
  end
end
