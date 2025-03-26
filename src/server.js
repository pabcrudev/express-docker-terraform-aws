const express = require("express");

("use strict");

/**
 * Express application for a basic server
 * @module server
 */

const app = express();
const PORT = process.env.PORT || 80;
const HOST = process.env.HOST || "localhost";

/**
 * Sets up basic middleware and routes
 */
function setupServer() {
  // Basic middleware for JSON parsing
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // Root route
  app.get("/", (_, res) => {
    res.send({ response: "Hi, Amazon Web Service" });
  });
}

/**
 * Initializes and starts the Express server
 */
function startServer() {
  const server = app.listen(PORT, () => {
    console.log(`Server is running on http://${HOST}:${PORT}`);
  });

  return server;
}

// Initialize server
setupServer();
startServer();

// Export for testing purposes
module.exports = app;
