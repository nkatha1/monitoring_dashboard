# Real-Time Monitoring Dashboard 🖥️📊

A **Flutter Web dashboard** for real-time server monitoring, displaying CPU usage, memory usage, and request rates with live updates and interactive charts.  
The backend is a Node.js server emitting metrics via **WebSockets**, deployed on **Render**, while the frontend is built with **Flutter Web**.

---

## 🚀 Live Demo

- Frontend (Web): [Your Netlify/Frontend URL]  
- Backend (API/WebSocket): [https://backend-02c2.onrender.com](https://backend-02c2.onrender.com)

---

## 📁 Project Structure

monitoring_dashboard/
├─ backend/ # Node.js backend with WebSocket metrics
├─ frontend/ # Flutter frontend (web app)
│ ├─ lib/ # Flutter Dart code (main.dart)
│ ├─ pubspec.yaml # Dependencies and Flutter configuration
└─ README.md # Project documentation


---

## 🛠️ Tech Stack

- **Frontend:** Flutter Web, fl_chart, socket_io_client  
- **Backend:** Node.js, Express, socket.io  
- **Deployment:** Render (backend), Netlify (frontend)  

---

## 💻 Local Setup

### 1️⃣ Clone the repository

```bash
git clone https://github.com/nkatha1/monitoring_dashboard.git
cd monitoring_dashboard


2️⃣ Backend (Node.js)
cd backend
npm install
npm start

Runs the backend on http://localhost:3000

Emits live metrics via WebSocket (/metrics event)

3️⃣ Frontend (Flutter Web)

cd frontend
flutter pub get

Update Backend URL

In frontend/lib/main.dart, update the WebSocket connection to point to your backend:

socket = IO.io(
  'https://backend-02c2.onrender.com', // <-- deployed backend URL
  IO.OptionBuilder()
      .setTransports(['websocket'])
      .setReconnectionAttempts(5)
      .build(),
);

4️⃣ Run Locally

flutter run -d chrome

Opens the app in a local browser window

Connects to your backend and shows live metrics

5️⃣ Build for Production (Web)

flutter build web

Generates the production-ready frontend in frontend/build/web/

Can be deployed to Netlify, Vercel, or any static host

🌐 Deployment
Backend (Render)

Already deployed at: https://backend-02c2.onrender.com

Ensure start script in backend/package.json is:

"scripts": {
  "start": "node server.js"
}

Frontend (Netlify)

Drag-and-drop frontend/build/web folder into Netlify dashboard OR connect via GitHub

Ensure backend URL in main.dart is the deployed Render URL

📝 Features

Real-time metrics (CPU, memory, requests/sec) via WebSocket

Historical line charts (last 30 seconds)

Responsive cards for quick overview

Live updates without page reload

⚡ Notes

Frontend requires Flutter >= 3.7.2

Backend requires Node.js >= 18

Make sure CORS/WebSocket access is allowed if frontend is on a different domain

💡 Improvements & Next Steps

Add user authentication to protect metrics

Allow custom time ranges in charts

Enable alerts when thresholds are exceeded

Add dark mode and UI themes

📄 License

MIT License

✨ Built with Flutter, Node.js, and ❤️ by Patience Nkatha
