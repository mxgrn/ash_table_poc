# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AshTable.Repo.insert!(%AshTable.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Insert data into the "books" table
[
  %{title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925},
  %{title: "The Grapes of Wrath", author: "John Steinbeck", year: 1939},
  %{title: "Nineteen Eighty-Four", author: "George Orwell", year: 1949},
  %{title: "Ulysses", author: "James Joyce", year: 1922}
]
|> Enum.map(fn book ->
  AshTable.Book
  |> Ash.Changeset.for_create(:create, %{
    title: book.title,
    author: book.author,
    year: book.year
  })
  |> AshTable.Library.create!()
end)
