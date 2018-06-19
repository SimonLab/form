CREATE TABLE IF NOT EXISTS replies (
  id SERIAL PRIMARY KEY,
  form_reply_id INTEGER REFERENCES form_replies (id),
  answer_id INTEGER REFERENCES answers (id)
);
