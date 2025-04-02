const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const admin = require('firebase-admin');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
    cors: { origin: '*' }
});

app.get('/', (req, res) => {
    res.send('Chat server is running');
});

// Firebase Admin Setup
const serviceAccount = require('./firebase-adminsdk.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

// Store connected users
let users = {};

io.on('connection', (socket) => {
    console.log('A user connected:', socket.id);

    socket.on('register', (token) => {
        users[socket.id] = token;
        console.log('User registered for notifications:', token);
    });

    socket.on('message', (data) => {
        console.log('Message received:', data);
        io.emit('message', data);  // Broadcast message

        // Send push notification
        const payload = {
            notification: {
                title: 'New Message',
                body: data
            },
            token: users[socket.id]
        };

        admin.messaging().send(payload)
            .then(response => console.log('Notification sent:', response))
            .catch(error => console.log('Error sending notification:', error));
    });

    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
        delete users[socket.id];
    });
});

const PORT = 3001;

server.on('error', (error) => {
    if (error.code === 'EADDRINUSE') {
        console.error(`Port ${PORT} is already in use. Please make sure no other server is running on this port.`);
        process.exit(1);
    } else {
        console.error('Server error:', error);
    }
});

server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
