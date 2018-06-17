var express = require("express");
var router = express.Router();

router.get("/new", function(req, res, next) {
  return res.render("form/new", {});
});

module.exports = router;
