CREATE TABLE IF NOT EXISTS answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER REFERENCES questions (id),
  reply_id INTEGER REFERENCES replies (id),
  value TEXT NOT NULL,
  num INTEGER
);
