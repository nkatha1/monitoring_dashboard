// Import required core and third-party modules
const express = require("express");        // Web framework for APIs
const http = require("http");              // Node HTTP server
const { Server } = require("socket.io");   // WebSocket library
const cors = require("cors");              // Allow cross-origin requests

// Create Express application
const app = express();

// Enable CORS so Flutter Web can connect
app.use(cors());

// Wrap Express app with HTTP server
const server = http.createServer(app);

// Attach Socket.IO to the HTTP server
const io = new Server(server, {
  cors: {
    origin: "*", // Allow any frontend to connect (safe for demo)
  },
});

// ----------------------------
// Utility: Generate fake system metrics
// ----------------------------
function generateMetrics() {
  return {
    cpu: Math.floor(Math.random() * 100),       // CPU usage %
    memory: Math.floor(Math.random() * 100),    // Memory usage %
    requests: Math.floor(Math.random() * 500),  // Requests per second
    timestamp: new Date(),                      // Time of metric
  };
}

// ----------------------------
// WebSocket connection handler
// ----------------------------
io.on("connection", (socket) => {
  console.log("Client connected");

  // Send metrics to the client every 1 second
  const interval = setInterval(() => {
    const metrics = generateMetrics();
    socket.emit("metrics", metrics); // Emit event to frontend
  }, 1000);

  // Cleanup when client disconnects
  socket.on("disconnect", () => {
    clearInterval(interval);
    console.log("Client disconnected");
  });
});

// ----------------------------
// Start the server
// ----------------------------
const PORT = 3000;

server.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`);
});
