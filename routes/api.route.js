const express = require("express");
const app = express();
app.use(express.json());
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

app.get("/twitter", async (req, res) => {
  try {
    const tweets = await prisma.tweetsRetweets.findMany({
      include: { user: true },
    });
    res.json(tweets);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.get("/user", async (req, res) => {
  try {
    const user = await prisma.user.findMany({});
    res.json(user);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).send("Internal Server Error");
  }
});

app.post("/twitter", async (req, res) => {
  try {
    const tweets = await prisma.tweetsRetweets.create({
      data: req.body,
    });
    res.send(tweets);
  } catch (error) {
    res.send(error);
  }
});

app.post("/user", async (req, res) => {
  try {
    const user = await prisma.user.create({
      data: req.body,
    });
    res.send(user);
  } catch (error) {
    res.send(error);
  }
});

app.delete("/twitter/:id", async (req, res) => {
  const id = parseInt(req.params.id);
  try {
    const deletedTweet = await prisma.tweetsRetweets.delete({
      where: {
        id: id,
      },
    });

    res.json(deletedTweet);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.delete("/user/:id", async (req, res) => {
  const id = parseInt(req.params.id);
  try {
    const deleted = await prisma.user.delete({
      where: {
        id: id,
      },
    });

    res.json(deleted);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.patch("/user/:id", async (req, res) => {
  try {
    const { content } = req.body;
    const user = await prisma.user.update({
      where: { id: Number(req.params.id) },
      data: req.body,
    });

    res.send(user);
  } catch (error) {
    res.status(404).send("Not Found");
  }
});

app.patch("/twitter/:id", async (req, res) => {
  try {
    const { content } = req.body;
    const tweets = await prisma.tweetsRetweets.update({
      where: { id: Number(req.params.id) },
      data: { content: content },
    });

    res.send(tweets);
  } catch (error) {
    console.log(error);
    res.status(404).send("not found");
  }
});

module.exports = app;
