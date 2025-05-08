import 'package:flutter/material.dart';
import 'package:app/core/token/border_radius_tokens.dart';

import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:app/widgets/custom_bottom_nav_bar.dart';

// ---------------------- MAIN SCREEN ----------------------
class TinderHomeScreen extends StatefulWidget {
  const TinderHomeScreen({Key? key}) : super(key: key);

  @override
  _TinderHomeScreenState createState() => _TinderHomeScreenState();
}

class _TinderHomeScreenState extends State<TinderHomeScreen> {
  int _selectedNavIndex = 0; // Track selected navigation item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      // Main layout with card stack and bottom navigation
      body: Column(
        children: [
          // Card stack takes most of the screen space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: ProfileCardStack(),
            ),
          ),
          // Custom bottom navigation bar
          CustomBottomNavBar(
            selectedIndex: _selectedNavIndex,
            onItemTapped: (index) => setState(() => _selectedNavIndex = index),
          ),
        ],
      ),
    );
  }
}

// ---------------------- USER DATA MODEL ----------------------
class UserProfile {
  final String name;
  final int age;
  final String location;
  final String distance;
  final String photoUrl;

  // Constructor requiring all profile information
  UserProfile({
    required this.name,
    required this.age,
    required this.location,
    required this.distance,
    required this.photoUrl,
  });
}

// ---------------------- PROFILE CARD STACK ----------------------
class ProfileCardStack extends StatefulWidget {
  @override
  _ProfileCardStackState createState() => _ProfileCardStackState();
}

class _ProfileCardStackState extends State<ProfileCardStack> with TickerProviderStateMixin {
  // Sample user profile data
  final List<UserProfile> profiles = [
    UserProfile(
      name: "Paulo", age: 29,
      location: "Lives in Alfama",
      distance: "1 kilometer away",
      photoUrl: "assets/images/backgroud.png",
    ),
    UserProfile(
      name: "Maria", age: 25,
      location: "Lives in Lisbon",
      distance: "2 kilometers away",
      photoUrl: "assets/images/backgroud.png",
    ),
    UserProfile(
      name: "João", age: 31,
      location: "Lives in Porto",
      distance: "5 kilometers away",
      photoUrl: "assets/images/backgroud.png",
    ),
  ];

  int currentIndex = 0;               // Index of the currently shown profile
  List<Key> cardKeys = [];            // Unique keys for each card
  late AnimationController _nextCardAnimController;  // Controls next card animation
  late Animation<double> _nextCardScaleAnimation;    // Scale animation for next card

  @override
  void initState() {
    super.initState();
    // Generate unique keys for each profile card
    cardKeys = List.generate(profiles.length, (index) => UniqueKey());

    // Setup animation for revealing the next card
    _nextCardAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Scale animation from 90% to 100%
    _nextCardScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _nextCardAnimController, curve: Curves.easeInOut)
    );
  }

  @override
  void dispose() {
    _nextCardAnimController.dispose();
    super.dispose();
  }

  // Move to next profile in the stack
  void nextProfile() {
    setState(() {
      // Cycle through profiles
      currentIndex = (currentIndex < profiles.length - 1) ? currentIndex + 1 : 0;

      // Reset and start animation for next card
      _nextCardAnimController.reset();
      _nextCardAnimController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const Center(child: Text("No profiles available"));
    }

    // Stack of profile cards (showing current and next card)
    return Stack(
      children: List.generate(
        2, // Only generate 2 cards (current and next)
            (index) {
          if (currentIndex + index >= profiles.length) {
            return const SizedBox.shrink(); // No more profiles
          }

          int displayIndex = (currentIndex + index) % profiles.length;
          bool isTopCard = index == 0;

          return Positioned.fill(
            child: isTopCard
                ? ProfileCard( // Top card (current profile)
              key: cardKeys[displayIndex],
              name: profiles[displayIndex].name,
              age: profiles[displayIndex].age,
              location: profiles[displayIndex].location,
              distance: profiles[displayIndex].distance,
              photoUrl: profiles[displayIndex].photoUrl,
              onSwipeRight: nextProfile,
              onSwipeLeft: nextProfile,
              isTopCard: true,
            )
                : AnimatedBuilder( // Next card with scale animation
              animation: _nextCardAnimController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _nextCardScaleAnimation.value,
                  child: ProfileCard(
                    key: cardKeys[displayIndex],
                    name: profiles[displayIndex].name,
                    age: profiles[displayIndex].age,
                    location: profiles[displayIndex].location,
                    distance: profiles[displayIndex].distance,
                    photoUrl: profiles[displayIndex].photoUrl,
                    onSwipeRight: () {}, // No action for background card
                    onSwipeLeft: () {},  // No action for background card
                    isTopCard: false,
                  ),
                );
              },
            ),
          );
        },
      ).reversed.toList(), // Reverse stack so top card appears on top
    );
  }
}

// ---------------------- INDIVIDUAL PROFILE CARD ----------------------
class ProfileCard extends StatefulWidget {
  final String name;
  final int age;
  final String location;
  final String distance;
  final String photoUrl;
  final VoidCallback onSwipeRight;  // Called when card is swiped right
  final VoidCallback onSwipeLeft;   // Called when card is swiped left
  final bool isTopCard;             // Whether this is the currently active card

  const ProfileCard({
    Key? key,
    required this.name,
    required this.age,
    required this.location,
    required this.distance,
    required this.photoUrl,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.isTopCard,
  }) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> with SingleTickerProviderStateMixin {
  // Card state variables
  double _dragPosition = 0.0;       // Current horizontal drag position
  bool _isDragging = false;         // Whether card is being dragged
  bool _showLikeOverlay = false;    // Show "LIKE" overlay
  bool _showDislikeOverlay = false; // Show "NOPE" overlay

  // UI colors for action buttons
  Color _likeButtonColor = Colors.teal;
  Color _dislikeButtonColor = Colors.red;

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _animation;        // Position animation
  late Animation<double> _rotationAnimation; // Rotation animation

  @override
  void initState() {
    super.initState();
    // Setup animation controller for card swipe animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Default animations (will be updated during interactions)
    _animation = Tween<double>(begin: 0, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Handle card dragging
  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.isTopCard) return; // Only top card can be dragged

    setState(() {
      _isDragging = true;
      _dragPosition += details.delta.dx; // Update horizontal position

      // Show like/dislike overlays based on drag direction
      _showLikeOverlay = _dragPosition > 50;    // Show LIKE when dragged right
      _showDislikeOverlay = _dragPosition < -50; // Show NOPE when dragged left
    });
  }

  // Handle end of drag
  void _handleDragEnd(DragEndDetails details) {
    if (!widget.isTopCard) return;

    const double swipeThreshold = 120.0; // Threshold for registering a swipe
    final double velocity = details.velocity.pixelsPerSecond.dx;
    final bool shouldSwipe = _dragPosition.abs() > swipeThreshold || velocity.abs() > 800;

    setState(() {
      _isDragging = false;

      if (shouldSwipe) {
        // Card was swiped far enough or with enough velocity
        final bool isRightSwipe = _dragPosition > 0 || velocity > 800;

        // Animate card off screen
        _animation = Tween<double>(
          begin: _dragPosition,
          end: isRightSwipe ? 500 : -500, // Move right or left off screen
        ).animate(_controller);

        _rotationAnimation = Tween<double>(
          begin: _dragPosition * 0.002,
          end: isRightSwipe ? 0.3 : -0.3, // Rotate based on direction
        ).animate(_controller);

        // Start animation and call appropriate callback when done
        _controller.forward(from: 0).then((_) {
          if (isRightSwipe) {
            widget.onSwipeRight();
          } else {
            widget.onSwipeLeft();
          }

          // Reset card state
          setState(() {
            _dragPosition = 0;
            _showLikeOverlay = false;
            _showDislikeOverlay = false;
            _controller.reset();
          });
        });
      } else {
        // Card wasn't swiped far enough, spring back to center
        _animation = Tween<double>(
          begin: _dragPosition,
          end: 0,
        ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.elasticOut)
        );

        _rotationAnimation = Tween<double>(
          begin: _dragPosition * 0.002,
          end: 0,
        ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.elasticOut)
        );

        // Start spring-back animation
        _controller.forward(from: 0).then((_) {
          setState(() {
            _dragPosition = 0;
            _showLikeOverlay = false;
            _showDislikeOverlay = false;
          });
        });
      }
    });
  }

  // Handle like button tap
  void _handleLikeButtonPressed() {
    if (!widget.isTopCard) return;

    setState(() {
      _showLikeOverlay = true;
      _dragPosition = 100; // Start with slight offset
    });

    // Setup animation to swipe right
    _animation = Tween<double>(begin: 100, end: 500).animate(_controller);
    _rotationAnimation = Tween<double>(begin: 0.1, end: 0.3).animate(_controller);

    // Start animation and call callback when done
    _controller.forward(from: 0).then((_) {
      widget.onSwipeRight();
      setState(() {
        _dragPosition = 0;
        _showLikeOverlay = false;
        _controller.reset();
      });
    });
  }

  // Handle dislike button tap
  void _handleDislikeButtonPressed() {
    if (!widget.isTopCard) return;

    setState(() {
      _showDislikeOverlay = true;
      _dragPosition = -100; // Start with slight offset
    });

    // Setup animation to swipe left
    _animation = Tween<double>(begin: -100, end: -500).animate(_controller);
    _rotationAnimation = Tween<double>(begin: -0.1, end: -0.3).animate(_controller);

    // Start animation and call callback when done
    _controller.forward(from: 0).then((_) {
      widget.onSwipeLeft();
      setState(() {
        _dragPosition = 0;
        _showDislikeOverlay = false;
        _controller.reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate card dimensions based on screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = screenWidth - 32 ;
    double cardHeight = screenHeight * 0.75;

    return Column(
      children: [
        // Card with drag gesture detection
        GestureDetector(
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                // Position based on drag or animation
                offset: Offset(_isDragging ? _dragPosition : _animation.value, 0),
                child: Transform.rotate(
                  // Rotation based on drag position or animation
                  angle: _isDragging ? _dragPosition * 0.001 : _rotationAnimation.value,
                  child: _buildCardContent(cardWidth, cardHeight),
                ),
              );
            },
          ),
        ),

        // Action buttons (only for top card)
        if (widget.isTopCard)
          _buildActionButtons(),
      ],
    );
  }

  // Build the card content with photo and profile info
  Widget _buildCardContent(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Profile Image
          Positioned.fill(
            child: Image.asset(widget.photoUrl, fit: BoxFit.cover),
          ),

          // Gradient overlay for better text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color.fromRGBO(0, 0, 0, 0.8),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),

          // Like overlay ("LIKE" text in top right)
          if (_showLikeOverlay && widget.isTopCard)
            Positioned(
              top: 20,
              right: 20,
              child: Transform.rotate(
                angle: -0.2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "LIKE",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),

          // Dislike overlay ("NOPE" text in top left)
          if (_showDislikeOverlay && widget.isTopCard)
            Positioned(
              top: 20,
              left: 20,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "NOPE",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),

          // Profile Info at bottom of card (FIXED - moved to bottom)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name, age and info button
                Row(
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${widget.age}",
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    // Info button
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Location info
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Distance info
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.distance,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Action buttons row (rewind, dislike, super like, like, boost)
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Rewind button (yellow)
          _buildActionButton(
            Colors.amber,
            Icons.replay,
            onPressed: () {}, // Rewind functionality
            size: 48,
          ),
          // Dislike button (red)
          _buildActionButton(
            _dislikeButtonColor,
            Icons.close,
            onPressed: _handleDislikeButtonPressed,
            size: 56,
            borderColor: _showDislikeOverlay ? Colors.red : null,
          ),
          // Super like button (blue)
          _buildActionButton(
            Colors.blue,
            Icons.star,
            onPressed: () {}, // Super like functionality
            size: 48,
          ),
          // Like button (green)
          _buildActionButton(
            _likeButtonColor,
            Icons.favorite,
            onPressed: _handleLikeButtonPressed,
            size: 56,
            borderColor: _showLikeOverlay ? Colors.green : null,
          ),
          // Boost button (purple)
          _buildActionButton(
            Colors.purple,
            Icons.flash_on,
            onPressed: () {}, // Boost functionality
            size: 48,
          ),
        ],
      ),
    );
  }

  // Helper method to build circular action buttons
  Widget _buildActionButton(
      Color color,
      IconData icon, {
        required VoidCallback onPressed,
        Color? borderColor,
        double size = 50,
      }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size * 0.5,
        ),
      ),
    );
  }
}