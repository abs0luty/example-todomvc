import gleam/string
import gleam/http
import todomvc/item
import todomvc/user
import todomvc/tests
import gleeunit/should

pub fn home_test() {
  use db <- tests.with_db

  let uid1 = user.insert_user(db)
  assert Ok(_) = item.insert_item("Wibble", uid1, db)
  assert Ok(_) = item.insert_item("Wobble", uid1, db)
  let uid2 = user.insert_user(db)
  assert Ok(_) = item.insert_item("Wabble", uid2, db)

  assert Ok(response) =
    tests.request(http.Get, path: [], body: "", user_id: uid1, db: db)

  response.status
  |> should.equal(200)

  response.body
  |> string.contains("Wibble")
  |> should.equal(True)

  response.body
  |> string.contains("Wobble")
  |> should.equal(True)

  // An item belonging to another user is not included
  response.body
  |> string.contains("Wabble")
  |> should.equal(False)
}
