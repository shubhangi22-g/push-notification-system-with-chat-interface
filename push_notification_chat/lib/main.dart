import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
// Conditional import for web platform

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late io.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    _initializeSocket();
    _initializeFCM();
  }

  void _initializeSocket() {
    String host = 'localhost';
    int port = 3001;
    print('Connecting to WebSocket at http://$host:$port');
    socket = io.io(
      'http://$host:$port',
      io.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .enableForceNew()
        .enableAutoConnect()
        .enableReconnection()
        .setReconnectionAttempts(5)
        .setReconnectionDelay(1000)
        .build()
    );

    socket.onConnect((_) {
      print('Connected to WebSocket server');
      setState(() {
        messages.add('Connected to chat server');
      });
    });

    socket.onConnectError((error) {
      print('Connection error: $error');
      setState(() {
        messages.add('Failed to connect to chat server. Please try again.');
      });
    });

    socket.onDisconnect((_) {
      print('Disconnected from WebSocket server');
      setState(() {
        messages.add('Disconnected from chat server');
      });
    });
    socket.onConnect((_) => print('Connected to WebSocket'));
    socket.on('message', (data) {
      setState(() => messages.add(data));
    });
  }

  void _initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received notification: \${message.notification?.body}');
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      socket.emit('message', _messageController.text);
      setState(() => messages.add(_messageController.text));
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat App')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(messages[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
