defmodule AshTable.Ash.Users do
  use Ash.Api, extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    registry AshTable.Ash.Users.Registry
  end
end
