var express = require("express");
var router = express.Router();

router.get("/new", function(req, res, next) {
  return res.render("form/new", {});
});

router.post("/create", function(req, res, next) {
  console.log(req.body);
  return res.json({ok: true});
});

module.exports = router;
