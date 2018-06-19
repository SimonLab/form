require("env2")(".env");
var fs = require("fs");
var db = require("./db.js");
var path = require('path');

// create tables - find a better way!
var forms = fs.readFileSync(path.join(__dirname, "schemas/forms.sql")).toString();
var questions = fs.readFileSync(path.join(__dirname, "schemas/questions.sql")).toString();
var answers = fs.readFileSync(path.join(__dirname, "schemas/answers.sql")).toString();
var formReplies = fs.readFileSync(path.join(__dirname, "schemas/form_replies.sql")).toString();
var replies = fs.readFileSync(path.join(__dirname, "schemas/replies.sql")).toString();

db.query(forms, [], (err, result) => {
  db.query(questions, [], (err, result) => {
    db.query(answers, [], (err, result) => {
      db.query(formReplies, [], (err, result) => {
        db.query(replies, [], (err, result) => {
          return  "ok";
        });
      });
    });
  });
});
