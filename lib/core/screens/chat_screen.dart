import 'package:app/apis/services/chat_service.dart';
import 'package:app/core/utils/socket_service.dart';
import 'package:app/models/message_model.dart';
import 'package:app/providers/user_provicer.dart';
import 'package:app/widgets/message_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();

  Map<String, dynamic>? selectedUser;
  String conversationId = '';
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SocketService _socketService = SocketService();
  final List<Message> _messages = [];
  String? _currentUserId;
  String? _selectedReceiverId;
  bool _isConnected = false;
  List<dynamic> _onlineUsers = [];
  late StreamSubscription _messageSubscription;
  late StreamSubscription _usersSubscription;
  late StreamSubscription _connectionSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processRouteArguments();
    });
  }
  void _processRouteArguments() {
      final GoRouterState state = GoRouterState.of(context);
    final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;

    if (extra != null) {
      setState(() {
        selectedUser = extra['user'];
        conversationId = extra['conversationId'] ?? '';
        _selectedReceiverId = selectedUser?["_id"];
        print("Selected User: $selectedUser");
      });
      _initializeChat();
    } else {
      print("No arguments received");
    }
  }

  Future<void> _getMessage(String conversationId) async {
    try {
      final response = await _chatService.getMessage(conversationId);

      List<dynamic> messagesData = response["data"];

      setState(() {
        _messages.clear();
        _messages.addAll(messagesData.map((msg) => Message.fromJson(msg)).toList());
      });

      _scrollToBottom();

    } catch (e) {
      print("Error fetching messages: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load messages. Try again.")),
      );
    }
  }

  Future<void> _storeMessage(BuildContext context, String message) async{
    try{
      await _chatService.createMessage(message, _currentUserId!, _selectedReceiverId!, conversationId);
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't send message. Try again.")));
      print("Error: $e");
    }
  }

  void _initializeChat() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _currentUserId = userProvider.id;

    if (_currentUserId != null) {
      _socketService.initSocket(_currentUserId!);

      _messageSubscription = _socketService.onMessage.listen((data) {
        print("data : $data");
        setState(() {
          _messages.add(Message(
            senderId: data['senderId'],
            receiverId: data['receiverId'],
            text: data['text'],
            timestamp: DateTime.now().toUtc(),
          ));
        });
        _scrollToBottom();
      });

      _usersSubscription = _socketService.onUsersUpdate.listen((users) {
        setState(() {
          _onlineUsers = users;
        });
      });

      _connectionSubscription = _socketService.onConnectionStatus.listen((status) {
        setState(() {
          _isConnected = status;
        });
      });

      if (conversationId.isNotEmpty) {
        _getMessage(conversationId);
      }
    }
  }

  void _scrollToBottom() {
    // Add a slight delay to ensure the list view has been updated
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty ||
        _selectedReceiverId == null ||
        _currentUserId == null) {
      return;
    }

    final messageText = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(Message(
        senderId: _currentUserId!,
        receiverId: _selectedReceiverId!,
        text: messageText,
        timestamp: DateTime.now(),
      ));
    });

    _socketService.sendMessage(
      senderId: _currentUserId!,
      receiverId: _selectedReceiverId!,
      text: messageText,
    );

    _scrollToBottom();
    _storeMessage(context, messageText);
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    _usersSubscription.cancel();
    _connectionSubscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              child: Text(
                (selectedUser?['username'] ?? 'U')[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedUser?['username'] ?? _selectedReceiverId ?? 'Unknown User',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  _isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isConnected ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isConnected ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: ListView.builder(
                key: const PageStorageKey('messageList'),
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final bool isMe = message.senderId == _currentUserId;

                  return MessageItem(
                    message: message,
                    isMe: isMe,
                    selectedUser: selectedUser,
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  color: Colors.blue,
                  onPressed: () {}, // Placeholder for attachment functionality
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  color: Colors.blue,
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