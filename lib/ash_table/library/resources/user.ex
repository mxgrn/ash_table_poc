defmodule AshTable.User do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "users"
    repo AshTable.Repo
  end

  # required by our library
  resource do
    plural_name :users
  end

  attributes do
    integer_primary_key(:id)

    attribute :first_name, :string do
      allow_nil?(false)
    end

    attribute :last_name, :string do
      allow_nil?(false)
    end

    attribute :birthdate, :date do
    end

    attribute :email, :string do
      allow_nil?(false)
    end

    timestamps()
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  code_interface do
    define_for AshTable.Library
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
  end
end
