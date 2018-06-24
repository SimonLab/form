var express = require("express");
var router = express.Router();
var db = require('../db/db.js');

router.get("/new", function(req, res, next) {
  return res.render("form/new", {});
});

router.post("/create", function(req, res, next) {
  db.query('INSERT INTO forms (name) VALUES ($1) RETURNING id;', [req.body.title], (err, result) => {
    if (err) {
      return next(err)
    }
    var idForm = result.rows[0].id;
    var questionValues = [];
    var anwerValues = []
    req.body.questions.forEach(function(question, index) {
      questionValues.push(`(${idForm}, '${question.question}', ${index})`);
    });
    db.query('INSERT INTO questions (form_id, question, num) VALUES '+ questionValues.join(',') +' RETURNING id;', [], (err, result) => {
      if (err) {
        return next(err)
      }
      var answerValues = [];
      req.body.questions.forEach(function(question, indexQuestion) {
        question.answers.forEach(function(answer, indexAnswer) {
          answerValues.push(`(${result.rows[indexQuestion].id}, '${answer}', ${indexAnswer})`);
        });
      });
      db.query('INSERT INTO answers (question_id, value, num) VALUES '+ answerValues.join(',') +' RETURNING id;', [], (err, result) => {
        return res.json({ok: true});
      });
    })
  });
});

// return array of question ids
function getQuestionIds(rows) {
  return rows.reduce(function(acc, val) {
    if (acc.indexOf(val.question_id) === -1) {
      acc.push(val.question_id);
      return acc;
    } else {
      return acc
    }
  }, [])
}

function getAnswers(rows) {
  return rows.map(function(answer) {
    return {
      answer_id: answer.answer_id,
      answer: answer.answer,
      question_id: answer.question_id
    }
  })
}

function groupQuestions(rows) {
  var questionIds = getQuestionIds(rows);
  var res = questionIds.map(function(id) {
    var answers = rows.filter(function(r) {
      return r.answer_question_id === id;
    });
    return { question_id: id,
             question: answers[0].question,
             answers: getAnswers(answers)
           }
  });
  return res;
}

router.get("/show/:id", function(req, res, next) {
  var idForm = req.params.id;
  var query = `SELECT
   forms.id as form_id,
   forms.name as title,
   questions.id as question_id,
   questions.question,
   answers.question_id as answer_question_id,
   answers.id as answer_id,
   answers.value as answer
   FROM forms
   LEFT JOIN questions ON forms.id = questions.form_id
   LEFT JOIN answers ON questions.id = answers.question_id
   WHERE forms.id = ${idForm};`
  db.query(query, [], (err, result) => {
    if (err) {
      return next(err)
    }
    var rows = result.rows;
    if (rows.length > 0) {
      var title = rows[0].title;
      var questions = groupQuestions(rows)

      res.render('form/show', {formData: {title: title, questions: questions}});
    } else {
      res.render('form/show', {formData: {title: `No form found with the id ${idForm}`}});
    }
  })
});



module.exports = router;
