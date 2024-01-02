defmodule AshTable.Ash.Users do
  use Ash.Api, extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    registry AshTable.Users.Registry
  end
end
