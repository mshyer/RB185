CREATE TABLE lists (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE NOT NULL
);

CREATE TABLE todos(
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  list_id integer REFERENCES lists(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  completed boolean default false
);