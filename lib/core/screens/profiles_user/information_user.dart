import 'package:flutter/material.dart';
import 'package:app/core/token/padding_tokens.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:app/widgets/custom_bottom_nav_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Biến trạng thái cho màu nút và hiển thị overlay
  Color _dislikeButtonColor = Colors.red;
  Color _likeButtonColor = Colors.green;
  bool _showDislikeOverlay = false;
  bool _showLikeOverlay = false;

  // Dữ liệu mẫu của người dùng
  final List<String> userPhotos = [
    'assets/images/backgroud.png',
    'assets/images/photo1.png',
    'assets/images/photo2.png',
  ]; // Thay bằng danh sách ảnh thực tế
  final Map<String, String> userInfo = {
    'Giới thiệu': 'Xin chào, mình là Paulo. Mình luôn sống thật với bản thân và thích sự quan tâm.',
    'Sở thích': 'Du lịch, chụp ảnh, nghe nhạc, và ăn uống.',
    'Công việc': 'Sinh viên ngành thiết kế đồ họa.',
    'Mục tiêu': 'Tìm một người bạn đồng hành để chia sẻ niềm vui trong cuộc sống.',
  };

  // PageController để điều khiển PageView
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Theo dõi thay đổi trang
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Xử lý sự kiện nhấn nút
  void _handleDislikeButtonPressed() {
    setState(() {
      _showDislikeOverlay = true;
      _showLikeOverlay = false;
    });
    // Thêm chức năng dislike tại đây
  }

  void _handleLikeButtonPressed() {
    setState(() {
      _showLikeOverlay = true;
      _showDislikeOverlay = false;
    });
    // Thêm chức năng like tại đây
  }

  // Tạo nút hành động
  Widget _buildActionButton(
      Color color,
      IconData icon, {
        required VoidCallback onPressed,
        double size = 48,
        Color? borderColor,
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

  // Tạo hàng các nút hành động
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: Colors.transparent, // Nền trong suốt để không che ảnh
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Nút Rewind (vàng)
          // _buildActionButton(
          //   Colors.amber,
          //   Icons.replay,
          //   onPressed: () {}, // Thêm chức năng rewind tại đây
          //   size: 48,
          // ),
          // Nút Dislike (đỏ)
          _buildActionButton(
            _dislikeButtonColor,
            Icons.close,
            onPressed: _handleDislikeButtonPressed,
            size: 56,
            borderColor: _showDislikeOverlay ? Colors.red : null,
          ),
          // Nút Super Like (xanh dương)
          // _buildActionButton(
          //   Colors.blue,
          //   Icons.star,
          //   onPressed: () {}, // Thêm chức năng super like tại đây
          //   size: 48,
          // ),
          // Nút Like (xanh lá)
          _buildActionButton(
            _likeButtonColor,
            Icons.favorite,
            onPressed: _handleLikeButtonPressed,
            size: 56,
            borderColor: _showLikeOverlay ? Colors.green : null,
          ),
          // Nút Boost (tím)
          // _buildActionButton(
          //   Colors.purple,
          //   Icons.flash_on,
          //   onPressed: () {}, // Thêm chức năng boost tại đây
          //   size: 48,
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nội dung cuộn
          CustomScrollView(
            slivers: [
              // Phần ảnh với SliverAppBar
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.6, // Chiều cao ban đầu
                floating: false,
                pinned: true, // Giữ thanh tiêu đề khi cuộn
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  title: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: AppPaddingTokens.paddingLg,
                        bottom: AppPaddingTokens.paddingMd,
                      ),
                      child: Text(
                        'Paulo, 29',
                        style: AppTheme.headLineMedium24.copyWith(
                          color: AppColors.primaryWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  background: Stack(
                    children: [
                      // PageView hiển thị ảnh
                      PageView.builder(
                        controller: _pageController,
                        itemCount: userPhotos.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            userPhotos[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      // Thanh chỉ báo trang
                      Positioned(
                        top: 40, // Cách đỉnh để tránh thanh trạng thái
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            userPhotos.length,
                                (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 20 : 8, // Chấm hiện tại dài hơn
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentPage == index ? Colors.white : Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppPaddingTokens.paddingLg),
                    child: IconButton(
                      icon: const Icon(Icons.download_rounded, color: AppColors.primaryWhite),
                      onPressed: () {context.go('/tinderUser');}, // Thêm chức năng download tại đây
                    ),
                  ),
                ],
              ),

              // Phần nội dung thông tin
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.all(AppPaddingTokens.paddingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thanh tìm kiếm + trạng thái
                      Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.neutralGray500),
                          const SizedBox(width: 8),
                          Text(
                            'Đang tìm kiếm',
                            style: AppTheme.bodySmall12.copyWith(color: AppColors.neutralGray600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '😍 Bạn hẹn hò lâu dài',
                        style: AppTheme.bodyMedium16.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // Các mục thông tin tách biệt
                      ...userInfo.entries.map((entry) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white, // Đặt màu nền trắng
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: AppTheme.bodyMedium14.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neutralGray800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry.value,
                                  style: AppTheme.bodySmall12.copyWith(
                                    color: AppColors.neutralGray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 100), // Khoảng trống để tránh che nút hành động
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bộ nút hành động cố định ở dưới cùng
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }
}
