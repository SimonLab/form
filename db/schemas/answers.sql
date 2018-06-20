CREATE TABLE IF NOT EXISTS answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER REFERENCES questions (id),
  value TEXT NOT NULL,
  num INTEGER
);
