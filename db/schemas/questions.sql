CREATE TABLE IF NOT EXISTS questions (
  id SERIAL PRIMARY KEY,
  form_id INTEGER REFERENCES forms (id),
  question TEXT NOT NULL,
  num INTEGER
);
