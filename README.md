# push-notification-system-with-chat-interface
A real-time chat application with push notification support, built with Flutter (frontend) and Node.js (backend).

## Project Structure

```
├── push_notification_chat/        # Flutter Frontend
│   ├── lib/
│   │   ├── screens/              # UI screens
│   │   │   └── chat_screen.dart  # Main chat interface
│   │   ├── services/             # Business logic
│   │   │   └── messaging_service.dart  # Firebase & Socket.IO handling
│   │   └── main.dart             # App entry point
│   ├── web/                      # Web-specific files
│   │   └── firebase-config.js    # Firebase configuration
│   └── pubspec.yaml              # Flutter dependencies
│
└── push_notification_chat_backend/  # Node.js Backend
    ├── server.js                 # Server entry point
    ├── package.json              # Node.js dependencies
    └── firebase-adminsdk.json    # Firebase admin credentials
```

## Setup Instructions

### Frontend (Flutter)

1. Navigate to the frontend directory:
   ```bash
   cd push_notification_chat
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run -d chrome
   ```

### Backend (Node.js)

1. Navigate to the backend directory:
   ```bash
   cd push_notification_chat_backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the server:
   ```bash
   npm start
   ```

## Features

- Real-time chat messaging using Socket.IO
- Push notifications via Firebase Cloud Messaging
- Clean and intuitive user interface
- Cross-platform support (Web, Android, iOS)

## Dependencies
flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3          # For state management (BLoC Pattern)
  firebase_messaging: ^14.7.10   # For push notifications
  socket_io_client: ^2.0.3+1     # For WebSocket communication with Node.js server
  hive: ^2.2.3                   # For local storage
  hive_flutter: ^1.1.0           # Hive adapter for Flutter integration

### Frontend
- flutter_bloc: State management
- firebase_messaging: Push notifications
- socket_io_client: Real-time communication
- hive: Local storage
- firebase_core: Firebase initialization

### Backend
- express: Web server framework
- socket.io: Real-time communication
- firebase-admin: Firebase services

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
