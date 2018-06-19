var express = require("express");
var router = express.Router();
var db = require('../db/db.js');

router.get("/new", function(req, res, next) {
  return res.render("form/new", {});
});

router.post("/create", function(req, res, next) {
  console.log(req.body);
  db.query('INSERT INTO forms (name) VALUES ($1)', [req.body.title], (err, result) => {
    if (err) {
      return next(err)
    }
    console.log(result);
    // res.send(res.rows[0])
    return res.json({ok: true});
  });
});

module.exports = router;
