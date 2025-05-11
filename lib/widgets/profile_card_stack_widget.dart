import 'package:app/apis/services/chat_service.dart';
import 'package:app/apis/services/media_service.dart';
import 'package:app/apis/services/profile_service.dart';
import 'package:app/apis/services/user_service.dart';
import 'package:app/models/user-profile_model.dart';
import 'package:app/providers/user_provicer.dart';
import 'package:app/widgets/profle_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileCardStack extends StatefulWidget {
  @override
  _ProfileCardStackState createState() => _ProfileCardStackState();
}

class _ProfileCardStackState extends State<ProfileCardStack> with TickerProviderStateMixin {
  final UserService _userService = UserService();
  final ChatService _chatService = ChatService();
  final ProfileService _profileService = ProfileService();
  late String currentUserAvatar = '';
  List<dynamic> usersFromApi = [];
  late List<UserProfile> users = [];
  late String conversationId;

  int currentIndex = 0; // Index of the currently shown profile
  List<Key> cardKeys = []; // Unique keys for each card
  late AnimationController _nextCardAnimController; // Controls next card animation
  late Animation<double> _nextCardScaleAnimation; // Scale animation for next card

  @override
  void initState() {
    super.initState();

    _fetchUsers();

    // Setup animation for revealing the next card
    _nextCardAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Scale animation from 90% to 100%
    _nextCardScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(
            parent: _nextCardAnimController, curve: Curves.easeInOut)
    );
  }

  Future<void> _fetchUsers() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUserId = userProvider.id;

      // Get all users
      final response = await _userService.getAllUsers();

      setState(() {
        // Filter out the current user
        usersFromApi = response["data"].where((userData) =>
        userData["_id"] != currentUserId
        ).toList();

        // Create UserProfile objects from the API data
        users = usersFromApi.map<UserProfile>((userData) =>
            UserProfile.fromApiData(userData)
        ).toList();

        // Generate unique keys for each card
        cardKeys = List.generate(users.length, (index) => UniqueKey());
      });

      print('Fetched ${users.length} users (excluding current user)');
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> _openChatScreen(BuildContext context, dynamic user, String currentUserId) async {
    print('Opening chat with user: ${user["_id"]}');
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Show loading indicator
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text("Opening chat..."),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      final response = await _chatService.createConversation(currentUserId, user["_id"]);
      print(response);
      conversationId = response["data"]["_id"];

      if (!mounted) return;

      GoRouter.of(context).go('/chat', extra: {
        'user': user,
        'conversationId': conversationId,
      });
    } catch (e) {
      print(e);
      if (!mounted) return;

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Flexible(
                child: Text("Couldn't open chat. Try again."),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _openChatScreen(context, user, currentUserId),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nextCardAnimController.dispose();
    super.dispose();
  }

  // Move to next profile in the stack
  void nextProfile() {
    if (users.isEmpty) return;

    setState(() {
      // Cycle through users
      currentIndex = (currentIndex + 1) % users.length;

      // Reset and start animation for next card
      _nextCardAnimController.reset();
      _nextCardAnimController.forward();
    });

    print('Moved to user index: $currentIndex of ${users.length}');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUserId = userProvider.id;

    if (users.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading profiles...'),
          ],
        ),
      );
    }

    // Stack of profile cards (showing current and next card)
    return Stack(
      children: _buildCardStack(currentUserId),
    );
  }

  List<Widget> _buildCardStack([String? currentUserId]) {
    List<Widget> cards = [];

    if (users.isEmpty) {
      return [
        Center(
          child: Text('No profiles available'),
        ),
      ];
    }

    // Always add current card
    int currentUserIndex = currentIndex % users.length;
    UserProfile currentUser = users[currentUserIndex];

    // Get the avatar URL from the original API data
    String avatarUrl = '';
    if (currentUserIndex < usersFromApi.length &&
        usersFromApi[currentUserIndex]["profile"] != null &&
        usersFromApi[currentUserIndex]["profile"]["avatar"] != null) {
      avatarUrl = usersFromApi[currentUserIndex]["profile"]["avatar"]["filePath"];
    }

    cards.add(
        Positioned.fill(
          child: ProfileCard(
            key: cardKeys[currentUserIndex],
            name: currentUser.name,
            age: currentUser.age ?? 0,
            location: currentUser.gender ?? "Unknown location",
            distance: currentUser.distance ?? "Unknown distance",
            photoUrl: avatarUrl, // Use the correctly extracted avatar URL
            onSwipeRight: nextProfile,
            onSwipeLeft: nextProfile,
            isTopCard: true,
            onChat: () {
              if (currentUserId != null) {
                _openChatScreen(context, usersFromApi[currentUserIndex], currentUserId);
              }
            },
          ),
        )
    );

    // Add next card if available
    if (users.length > 1) {
      int nextUserIndex = (currentIndex + 1) % users.length;
      UserProfile nextUser = users[nextUserIndex];

      // Get the next avatar URL from the original API data
      String nextAvatarUrl = '';
      if (nextUserIndex < usersFromApi.length &&
          usersFromApi[nextUserIndex]["profile"] != null &&
          usersFromApi[nextUserIndex]["profile"]["avatar"] != null) {
        nextAvatarUrl = usersFromApi[nextUserIndex]["profile"]["avatar"]["filePath"];
      }

      cards.add(
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _nextCardAnimController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _nextCardScaleAnimation.value,
                  child: ProfileCard(
                    key: cardKeys[nextUserIndex],
                    name: nextUser.name,
                    age: nextUser.age ?? 0,
                    location: nextUser.location ?? "Unknown location",
                    distance: nextUser.distance ?? "Unknown distance",
                    photoUrl: nextAvatarUrl, // Use the correctly extracted avatar URL
                    onSwipeRight: () {},
                    // No action for background card
                    onSwipeLeft: () {},
                    // No action for background card
                    isTopCard: false,
                  ),
                );
              },
            ),
          )
      );
    }

    // Important: Return cards in reverse order so the top card appears on top
    return cards.reversed.toList();
  }
}