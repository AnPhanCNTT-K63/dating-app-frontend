// profile_card_widget.dart
import 'package:flutter/material.dart';
import 'package:app/widgets/profile_card_content_widget.dart';
import 'package:app/widgets/actionButtons_widget.dart';

class ProfileCard extends StatefulWidget {
  final String name;
  final int age;
  final String location;
  final String distance;
  final String photoUrl;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;
  final bool isTopCard;
  final VoidCallback? onChat;

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
    this.onChat,
  }) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> with SingleTickerProviderStateMixin {
  // Card state variables
  double _dragPosition = 0.0;
  bool _isDragging = false;
  bool _showLikeOverlay = false;
  bool _showDislikeOverlay = false;

  // UI colors for action buttons
  Color _likeButtonColor = Colors.teal;
  Color _dislikeButtonColor = Colors.red;

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
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
    if (!widget.isTopCard) return;

    setState(() {
      _isDragging = true;
      _dragPosition += details.delta.dx;

      // Show like/dislike overlays based on drag direction
      _showLikeOverlay = _dragPosition > 50;
      _showDislikeOverlay = _dragPosition < -50;
    });
  }

  // Handle end of drag
  void _handleDragEnd(DragEndDetails details) {
    if (!widget.isTopCard) return;

    const double swipeThreshold = 120.0;
    final double velocity = details.velocity.pixelsPerSecond.dx;
    final bool shouldSwipe = _dragPosition.abs() > swipeThreshold || velocity.abs() > 800;

    setState(() {
      _isDragging = false;

      if (shouldSwipe) {
        _handleSwipe(velocity);
      } else {
        _handleSpringBack();
      }
    });
  }

  void _handleSwipe(double velocity) {
    final bool isRightSwipe = _dragPosition > 0 || velocity > 800;

    // Animate card off screen
    _animation = Tween<double>(
      begin: _dragPosition,
      end: isRightSwipe ? 500 : -500,
    ).animate(_controller);

    _rotationAnimation = Tween<double>(
      begin: _dragPosition * 0.002,
      end: isRightSwipe ? 0.3 : -0.3,
    ).animate(_controller);

    // Start animation and call appropriate callback when done
    _controller.forward(from: 0).then((_) {
      if (isRightSwipe) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }

      _resetCardState();
    });
  }

  void _handleSpringBack() {
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

    _controller.forward(from: 0).then((_) {
      _resetCardState();
    });
  }

  void _resetCardState() {
    setState(() {
      _dragPosition = 0;
      _showLikeOverlay = false;
      _showDislikeOverlay = false;
      _controller.reset();
    });
  }

  // Handle like button tap
  void _handleLikeButtonPressed() {
    if (!widget.isTopCard) return;

    setState(() {
      _showLikeOverlay = true;
      _dragPosition = 100;
    });

    _animation = Tween<double>(begin: 100, end: 500).animate(_controller);
    _rotationAnimation = Tween<double>(begin: 0.1, end: 0.3).animate(_controller);

    _controller.forward(from: 0).then((_) {
      widget.onSwipeRight();
      _resetCardState();
    });
  }

  // Handle dislike button tap
  void _handleDislikeButtonPressed() {
    if (!widget.isTopCard) return;

    setState(() {
      _showDislikeOverlay = true;
      _dragPosition = -100;
    });

    _animation = Tween<double>(begin: -100, end: -500).animate(_controller);
    _rotationAnimation = Tween<double>(begin: -0.1, end: -0.3).animate(_controller);

    _controller.forward(from: 0).then((_) {
      widget.onSwipeLeft();
      _resetCardState();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate card dimensions based on screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = screenWidth - 32;
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
                offset: Offset(_isDragging ? _dragPosition : _animation.value, 0),
                child: Transform.rotate(
                  angle: _isDragging ? _dragPosition * 0.001 : _rotationAnimation.value,
                  child: ProfileCardContent(
                    width: cardWidth,
                    height: cardHeight,
                    name: widget.name,
                    age: widget.age,
                    location: widget.location,
                    distance: widget.distance,
                    photoUrl: widget.photoUrl,
                    showLikeOverlay: _showLikeOverlay && widget.isTopCard,
                    showDislikeOverlay: _showDislikeOverlay && widget.isTopCard,
                  ),
                ),
              );
            },
          ),
        ),

        // Action buttons (only for top card)
        if (widget.isTopCard)
          buildActionButtons(
              _dislikeButtonColor,
              _likeButtonColor,
              _showDislikeOverlay,
              _showLikeOverlay,
              _handleDislikeButtonPressed,
              _handleLikeButtonPressed,
              widget.onChat
          ),
      ],
    );
  }
}