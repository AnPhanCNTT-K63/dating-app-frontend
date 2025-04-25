import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../token/padding_tokens.dart';
import '../../token/border_radius_tokens.dart';

import '../../screens/onbroading/profile_add_photo.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() => setState(() => _currentTabIndex = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextTab() {
    if (_currentTabIndex < 5) {
      _tabController.animateTo(_currentTabIndex + 1);
    }
  }

  void _prevTab() {
    if (_currentTabIndex > 0) {
      _tabController.animateTo(_currentTabIndex - 1);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_currentTabIndex == 0 ? Icons.close : Icons.arrow_back, color: AppColors.neutralGray600),
          onPressed: () => _currentTabIndex == 0 ? context.go('/') : _prevTab(),
        ),
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  color: _currentTabIndex >= index ? AppColors.redRed400 : AppColors.neutralGray300,
                ),
              );
            }),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          NameTab(onContinue: _nextTab),
          BirthdayTab(onContinue: _nextTab),
          GenderTab(onContinue: _nextTab),
          InterestTab(onContinue: _nextTab),
          PhotoTab(onContinue: () => context.go('/home')),
        ],
      ),
    );
  }
}

class NameTab extends StatelessWidget {
  final VoidCallback onContinue;
  const NameTab({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPaddingTokens.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My first name is', style: AppTheme.headLineLarge32),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter your first name',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingSm),
          Text(
            'This is how it will appear in Tinder and you will not be able to change it',
            style: AppTheme.bodySmall12.copyWith(color: AppColors.neutralGray600),
          ),
          const Spacer(),
          ContinueButton(enabled: true, onPressed: onContinue),
        ],
      ),
    );
  }
}

class BirthdayTab extends StatelessWidget {
  final VoidCallback onContinue;
  const BirthdayTab({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPaddingTokens.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My birthday is', style: AppTheme.headLineLarge32),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
              LengthLimitingTextInputFormatter(10),
              TextInputFormatter.withFunction((oldValue, newValue) {
                String text = newValue.text;
                if (text.length == 4 || text.length == 7) {
                  if (!text.endsWith('/')) text += '/';
                }
                return TextEditingValue(
                  text: text,
                  selection: TextSelection.collapsed(offset: text.length),
                );
              })
            ],
            decoration: const InputDecoration(
              hintText: 'YYYY/MM/DD',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingSm),
          Text('Your age will be public', style: AppTheme.bodySmall12.copyWith(color: AppColors.neutralGray600)),
          const Spacer(),
          ContinueButton(enabled: true, onPressed: onContinue),
        ],
      ),
    );
  }
}

class GenderTab extends StatefulWidget {
  final VoidCallback onContinue;
  const GenderTab({required this.onContinue});

  @override
  State<GenderTab> createState() => _GenderTabState();
}

class _GenderTabState extends State<GenderTab> {
  bool showGender = false;
  String selected = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPaddingTokens.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('I am a', style: AppTheme.headLineLarge32),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selected = 'WOMAN'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: selected == 'WOMAN'
                        ? AppDecoration.genderSelected()
                        : AppDecoration.genderUnselected(),
                    alignment: Alignment.center,
                    child: Text(
                      'WOMAN',
                      style: AppTheme.titleSmall16.copyWith(
                        color: selected == 'WOMAN' ? AppColors.primaryWhite : AppColors.primaryBlack,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppPaddingTokens.paddingMd),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selected = 'MAN'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: selected == 'MAN'
                        ? AppDecoration.genderSelected()
                        : AppDecoration.genderUnselected(),
                    alignment: Alignment.center,
                    child: Text(
                      'MAN',
                      style: AppTheme.titleSmall16.copyWith(
                        color: selected == 'MAN' ? AppColors.primaryWhite : AppColors.primaryBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Row(
            children: [
              Checkbox(value: showGender, onChanged: (v) => setState(() => showGender = v!)),
              Text('Show my gender on my profile', style: AppTheme.bodySmall12),
            ],
          ),
          const Spacer(),
          ContinueButton(enabled: true, onPressed: widget.onContinue),
        ],
      ),
    );
  }
}
class InterestTab extends StatefulWidget {
  final VoidCallback onContinue;
  const InterestTab({super.key, required this.onContinue});

  @override
  State<InterestTab> createState() => _InterestTabState();
}

class _InterestTabState extends State<InterestTab> {
  final List<String> interests = [
    '90s Kid', 'Harry Potter', 'SoundCloud', 'Spa', 'Self Care',
    'Heavy Metal', 'House Parties', 'Gin Tonic', 'Gymnastics',
    'Hapkido', 'Hot Yoga', 'Meditation', 'Spotify', 'Sushi',
    'Hockey', 'Basketball', 'Slam Poetry', 'Home Workout',
    'Theater', 'Cafe Hopping', 'Aquarium', 'Sneakers', 'Instagram',
    'Hot Springs', 'Walking', 'Running', 'Travel'
  ];
  final Set<String> selected = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPaddingTokens.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Interests', style: AppTheme.headLineLarge32),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Text(
            "Let everyone know what you're interested in by adding it to your profile.",
            style: AppTheme.bodySmall12.copyWith(color: AppColors.neutralGray600),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: interests.map((interest) {
                  final isSelected = selected.contains(interest);
                  return GestureDetector(
                    onTap: () => setState(() =>
                    isSelected ? selected.remove(interest) : selected.add(interest)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
                        border: Border.all(color: isSelected ? AppColors.redRed500 : AppColors.neutralGray400),
                        color: isSelected ? Colors.transparent : AppColors.neutralGray100,
                      ),
                      child: Text(
                        interest,
                        style: AppTheme.bodySmall12.copyWith(
                          color: isSelected ? AppColors.redRed500 : AppColors.neutralGray800,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          ContinueButton(enabled: selected.isNotEmpty, onPressed: widget.onContinue),
        ],
      ),
    );
  }
}



class PhotoTab extends StatefulWidget {
  final VoidCallback onContinue;
  const PhotoTab({super.key, required this.onContinue});

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab> {
  final List<String?> photos = List.generate(6, (index) => null);

  void _addPhoto(int index, String path) {
    setState(() => photos[index] = path);
  }

  void _removePhoto(int index) {
    setState(() => photos[index] = null);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = photos.where((p) => p != null).length;
    return Padding(
      padding: EdgeInsets.all(AppPaddingTokens.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add photos', style: AppTheme.headLineLarge32),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Text(
            'Add at least 2 photos to continue',
            style: AppTheme.bodySmall12.copyWith(color: AppColors.neutralGray600),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Expanded(
            child: GridView.builder(
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final imagePath = photos[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusMedium),
                        color: AppColors.neutralGray200,
                      ),
                      alignment: Alignment.center,
                      child: imagePath != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                          : IconButton(
                        onPressed: () {
                          showPhotoPickerSheet(
                            context,
                            onImagePicked: (file) => _addPhoto(index, file.path),
                          );
                        },
                        icon: Icon(Icons.add, color: AppColors.redRed400),
                      ),
                    ),
                    if (imagePath != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, size: 14, color: Colors.red),
                          ),
                        ),
                      )
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          ContinueButton(enabled: selectedCount >= 2, onPressed: widget.onContinue),
        ],
      ),
    );
  }
}



class ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  const ContinueButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: enabled
              ? AppDecoration.createAccountButton()
              : BoxDecoration(
            color: AppColors.neutralGray300,
            borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
          ),
          alignment: Alignment.center,
          child: Text(
            'CONTINUE',
            style: AppTheme.titleSmall16.copyWith(
              color: enabled ? AppColors.primaryWhite : AppColors.neutralGray600,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
