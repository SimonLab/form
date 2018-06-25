CREATE TABLE IF NOT EXISTS form_replies (
  id SERIAL PRIMARY KEY,
  reply_id INTEGER REFERENCES replies (id),
  answer_id INTEGER REFERENCES answers (id)
);
