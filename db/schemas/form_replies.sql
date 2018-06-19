CREATE TABLE IF NOT EXISTS form_replies (
  id SERIAL PRIMARY KEY,
  form_id INTEGER REFERENCES forms (id),
);
