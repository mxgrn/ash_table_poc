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
  %{title: "Ulysses", author: "James Joyce", year: 1922},
  %{title: "Lolita", author: "Vladimir Nabokov", year: 1955},
  %{title: "Catch-22", author: "Joseph Heller", year: 1961},
  %{title: "The Catcher in the Rye", author: "J. D. Salinger", year: 1951},
  %{title: "Beloved", author: "Toni Morrison", year: 1987},
  %{title: "The Sound and the Fury", author: "William Faulkner", year: 1929},
  %{title: "To Kill a Mockingbird", author: "Harper Lee", year: 1960},
  %{title: "The Lord of the Rings", author: "J. R. R. Tolkien", year: 1954}
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

# Insert data into the "users" table
[
  %{first_name: "John", last_name: "Doe", email: "john.doe@example.com", birthdate: "1980-01-01"},
  %{first_name: "Jane", last_name: "Doe", email: "jane.doe@example.com", birthdate: "1980-01-01"},
  %{
    first_name: "John",
    last_name: "Smith",
    email: "john.smith@example.com",
    birthdate: "1970-01-01"
  },
  %{
    first_name: "Jane",
    last_name: "Smith",
    email: "jane.smith@example.com",
    birthdate: "1975-01-01"
  },
  %{
    first_name: "Michael",
    last_name: "Jackson",
    birthdate: "1958-08-29",
    email: "michael.jackson@example.com"
  },
  %{
    first_name: "Michael",
    last_name: "Jordan",
    birthdate: "1963-02-17",
    email: "michael.jordan@example.com"
  },
  %{
    first_name: "Michael",
    last_name: "Johnson",
    birthdate: "1967-09-13",
    email: "michael.johnson@example.com"
  },
  %{
    first_name: "Michael",
    last_name: "Moore",
    birthdate: "1954-04-23",
    email: "michael.moore@example.com"
  }
]
|> Enum.map(fn user ->
  AshTable.User
  |> Ash.Changeset.for_create(:create, user)
  |> AshTable.Library.create!()
end)
