require("env2")(".env");
var express = require("express");
var path = require("path");
var hbs = require("hbs");
var logger = require("morgan");

var indexRouter = require("./routes/index.js");
var formRouter = require("./routes/form.js");

var app = express();
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "hbs");
hbs.registerPartials(__dirname + "/views/partials");
hbs.registerHelper("json", function(obj) { return JSON.stringify(obj); });

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));
app.use(logger("dev"));
app.use("/", indexRouter);
app.use("/form", formRouter);

module.exports = app;
