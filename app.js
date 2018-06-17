var express = require("express");
var path = require("path");
var hbs = require("hbs");
var logger = require("morgan");

var indexRouter = require("./routes/index.js");

var app = express();
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "hbs");
app.use(express.static(path.join(__dirname, "public")));
app.use(logger("dev"));
app.use("/", indexRouter);

module.exports = app;
