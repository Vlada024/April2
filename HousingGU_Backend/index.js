const express = require("express");
const { PrismaClient } = require("@prisma/client");
const session = require("express-session");
const cors = require("cors");
const app = express();
const port = 5555;
const secretKey = "SAJKDHASJKDHAjsdahnasd!@#!@asdjkabJBAS";
const jwt = require("jsonwebtoken");
require("./chating");
app.use(cors());
app.use(express.json()); // makes every HTTP request A JSON Object
app.use("/uploads", express.static("uploads")); //Todo Photo Upload
app.use("/user", session({ secret: "fingerprint_customer", resave: true, saveUninitialized: true }));

app.use(function (req, res, next) {
	res.setHeader("Access-Control-Allow-Origin", "http://localhost:5173"); //http://192.168.100.2:5173
	res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, PATCH, DELETE");
	res.setHeader("Access-Control-Allow-Credentials", "true");
	res.setHeader("Content-Security-Policy-Report-Only", "default-src 'self'; script-src 'self'; style-src 'self'; font-src 'self'; img-src 'self'; frame-src 'self'");
	next();
});
app.use("/user/*", function authenticateToken(req, res, next) {
	const authHeader = req.headers["authorization"];
	const token = authHeader && authHeader.split(" ")[1];
	if (!token) {
		return res.status(401).send("unauthorized");
	}

	jwt.verify(token, secretKey, (err, user) => {
		if (err) {
			return res.status(402).send("invalid token");
		}
		req.user = user;
		next();
	});
});

const authRoute = require("./routes/auth");
const userRoute = require("./routes/user");
app.use(authRoute);
app.use(userRoute);
app.listen(port, () => {
	console.log(`server started at http://localhost:${port}`);
});

app.get("/", (req, res) => {
	res.send({ response: "ok", Message: "HousingGU home" });
});

app.get("/user/checkToken", (req, res) => {
	res.send({ response: "ok", Message: `You have a token for user ${req.user.username}` }); // Test for token
});
