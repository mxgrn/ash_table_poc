defmodule AshTable.Book do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :title, :string
    attribute :author, :string
    attribute :year, :integer
  end

  actions do
    # Add a set of simple actions. You'll customize these later.
    defaults [:create, :read, :update, :destroy]
  end

  postgres do
    table "books"
    repo AshTable.Repo
  end

  code_interface do
    # defines the API this resource should be called from
    define_for AshTable.Library
    # defining function Post.create/2 it calls the :create action
    define :create, action: :create
    # defining function Post.read_all/2 it calls the :read action
    define :read_all, action: :read
    # defining function Post.update/2 it calls the :update action
    define :update, action: :update
    # defining function Post.destroy/2 it calls the :destroy action
    define :destroy, action: :destroy
  end
end
