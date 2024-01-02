defmodule AshTable.Book do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "books"
    repo AshTable.Repo
  end

  # required
  resource do
    plural_name :books
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil?(false)
    end

    attribute :author, :string
    attribute :year, :integer
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
