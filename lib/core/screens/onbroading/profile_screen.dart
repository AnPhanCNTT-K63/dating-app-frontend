import 'package:app/models/user-profile_model.dart';
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
// Import the user profile model

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Create a user profile instance to store all the information
  final UserProfile _userProfile = UserProfile.empty();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(
      () => setState(() => _currentTabIndex = _tabController.index),
    );
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

  // Method to submit profile data to API
  Future<void> _submitProfile() async {
    // Check if profile is complete
    if (!_userProfile.isComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete your profile')),
      );
      return;
    }

    try {
      // Here you would make your API call
      // Example:
      // final response = await apiService.createProfile(_userProfile.toJson());

      // For now, just print the data that would be sent
      print('Submitting profile: ${_userProfile.toJson()}');

      // Navigate to home on success
      context.go('/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            _currentTabIndex == 0 ? Icons.close : Icons.arrow_back,
            color: AppColors.neutralGray600,
          ),
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
                  color:
                      _currentTabIndex >= index
                          ? AppColors.redRed400
                          : AppColors.neutralGray300,
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
          NameTab(
            onContinue: _nextTab,
            onNameChanged:
                (name) => setState(() => _userProfile.firstName = name),
            initialName: _userProfile.firstName,
          ),
          BirthdayTab(
            onContinue: _nextTab,
            onBirthdayChanged:
                (date) => setState(() => _userProfile.birthday = date),
            initialDate: _userProfile.birthday,
          ),
          GenderTab(
            onContinue: _nextTab,
            onGenderChanged:
                (gender) => setState(() => _userProfile.gender = gender),
            onShowGenderChanged:
                (show) => setState(() => _userProfile.showGender = show),
            initialGender: _userProfile.gender,
            initialShowGender: _userProfile.showGender,
          ),
          InterestTab(
            onContinue: _nextTab,
            onInterestsChanged:
                (interests) =>
                    setState(() => _userProfile.interests = interests),
            initialInterests: _userProfile.interests,
          ),
          PhotoTab(
            onContinue: _submitProfile,
            onPhotosChanged:
                (photos) => setState(() => _userProfile.photos = photos),
            initialPhotos: _userProfile.photos,
          ),
        ],
      ),
    );
  }
}

class NameTab extends StatefulWidget {
  final VoidCallback onContinue;
  final Function(String) onNameChanged;
  final String? initialName;

  const NameTab({
    required this.onContinue,
    required this.onNameChanged,
    this.initialName,
  });

  @override
  State<NameTab> createState() => _NameTabState();
}

class _NameTabState extends State<NameTab> {
  late TextEditingController _nameController;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _validateInput(_nameController.text);

    _nameController.addListener(() {
      _validateInput(_nameController.text);
      widget.onNameChanged(_nameController.text);
    });
  }

  void _validateInput(String value) {
    setState(() {
      _isValid = value.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPaddingTokens.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My first\nname is', style: AppTheme.headLineLarge32),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter your first name',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingSm),
          Text(
            'This is how it will appear in Tinder and you will not be able to change it',
            style: AppTheme.bodySmall12.copyWith(
              color: AppColors.neutralGray600,
            ),
          ),
          const Spacer(),
          ContinueButton(enabled: _isValid, onPressed: widget.onContinue),
        ],
      ),
    );
  }
}

class BirthdayTab extends StatefulWidget {
  final VoidCallback onContinue;
  final Function(DateTime) onBirthdayChanged;
  final DateTime? initialDate;

  const BirthdayTab({
    required this.onContinue,
    required this.onBirthdayChanged,
    this.initialDate,
  });

  @override
  State<BirthdayTab> createState() => _BirthdayTabState();
}

class _BirthdayTabState extends State<BirthdayTab> {
  late TextEditingController _birthdayController;
  bool _isValid = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _birthdayController = TextEditingController(
      text:
          _selectedDate != null
              ? "${_selectedDate!.year}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}"
              : '',
    );

    _birthdayController.addListener(() {
      _validateDate(_birthdayController.text);
    });
  }

  void _validateDate(String value) {
    if (value.length != 10) {
      setState(() {
        _isValid = false;
        _selectedDate = null;
      });
      return;
    }

    try {
      final parts = value.split('/');
      if (parts.length != 3) {
        setState(() {
          _isValid = false;
          _selectedDate = null;
        });
        return;
      }

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      if (year < 1900 ||
          year > DateTime.now().year ||
          month < 1 ||
          month > 12 ||
          day < 1 ||
          day > 31) {
        setState(() {
          _isValid = false;
          _selectedDate = null;
        });
        return;
      }

      final date = DateTime(year, month, day);

      // Check if user is at least 18 years old
      final today = DateTime.now();
      final minimumAge = DateTime(today.year - 18, today.month, today.day);

      if (date.isAfter(minimumAge)) {
        setState(() {
          _isValid = false;
          _selectedDate = null;
        });
        return;
      }

      setState(() {
        _isValid = true;
        _selectedDate = date;
      });

      if (_selectedDate != null) {
        widget.onBirthdayChanged(_selectedDate!);
      }
    } catch (e) {
      setState(() {
        _isValid = false;
        _selectedDate = null;
      });
    }
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

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
            controller: _birthdayController,
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
              }),
            ],
            decoration: const InputDecoration(
              hintText: 'YYYY/MM/DD',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingSm),
          Text(
            'Your age will be public',
            style: AppTheme.bodySmall12.copyWith(
              color: AppColors.neutralGray600,
            ),
          ),
          const Spacer(),
          ContinueButton(enabled: _isValid, onPressed: widget.onContinue),
        ],
      ),
    );
  }
}

class GenderTab extends StatefulWidget {
  final VoidCallback onContinue;
  final Function(String) onGenderChanged;
  final Function(bool) onShowGenderChanged;
  final String? initialGender;
  final bool initialShowGender;

  const GenderTab({
    required this.onContinue,
    required this.onGenderChanged,
    required this.onShowGenderChanged,
    this.initialGender,
    required this.initialShowGender,
  });

  @override
  State<GenderTab> createState() => _GenderTabState();
}

class _GenderTabState extends State<GenderTab> {
  late bool showGender;
  late String selected;

  @override
  void initState() {
    super.initState();
    showGender = widget.initialShowGender;
    selected = widget.initialGender ?? '';
  }

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
                  onTap: () {
                    setState(() => selected = 'WOMAN');
                    widget.onGenderChanged('WOMAN');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration:
                        selected == 'WOMAN'
                            ? AppDecoration.genderSelected()
                            : AppDecoration.genderUnselected(),
                    alignment: Alignment.center,
                    child: Text(
                      'WOMAN',
                      style: AppTheme.titleSmall16.copyWith(
                        color:
                            selected == 'WOMAN'
                                ? AppColors.primaryWhite
                                : AppColors.primaryBlack,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppPaddingTokens.paddingMd),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => selected = 'MAN');
                    widget.onGenderChanged('MAN');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration:
                        selected == 'MAN'
                            ? AppDecoration.genderSelected()
                            : AppDecoration.genderUnselected(),
                    alignment: Alignment.center,
                    child: Text(
                      'MAN',
                      style: AppTheme.titleSmall16.copyWith(
                        color:
                            selected == 'MAN'
                                ? AppColors.primaryWhite
                                : AppColors.primaryBlack,
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
              Checkbox(
                value: showGender,
                onChanged: (v) {
                  setState(() => showGender = v ?? false);
                  widget.onShowGenderChanged(showGender);
                },
              ),
              Text('Show my gender on my profile', style: AppTheme.bodySmall12),
            ],
          ),
          const Spacer(),
          ContinueButton(
            enabled: selected.isNotEmpty,
            onPressed: widget.onContinue,
          ),
        ],
      ),
    );
  }
}

class InterestTab extends StatefulWidget {
  final VoidCallback onContinue;
  final Function(List<String>) onInterestsChanged;
  final List<String> initialInterests;

  const InterestTab({
    super.key,
    required this.onContinue,
    required this.onInterestsChanged,
    required this.initialInterests,
  });

  @override
  State<InterestTab> createState() => _InterestTabState();
}

class _InterestTabState extends State<InterestTab> {
  final List<String> interests = [
    '90s Kid',
    'Harry Potter',
    'SoundCloud',
    'Spa',
    'Self Care',
    'Heavy Metal',
    'House Parties',
    'Gin Tonic',
    'Gymnastics',
    'Hapkido',
    'Hot Yoga',
    'Meditation',
    'Spotify',
    'Sushi',
    'Hockey',
    'Basketball',
    'Slam Poetry',
    'Home Workout',
    'Theater',
    'Cafe Hopping',
    'Aquarium',
    'Sneakers',
    'Instagram',
    'Hot Springs',
    'Walking',
    'Running',
    'Travel',
  ];
  late Set<String> selected;

  @override
  void initState() {
    super.initState();
    selected = Set.from(widget.initialInterests);
  }

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
            style: AppTheme.bodySmall12.copyWith(
              color: AppColors.neutralGray600,
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    interests.map((interest) {
                      final isSelected = selected.contains(interest);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selected.remove(interest);
                            } else {
                              selected.add(interest);
                            }
                          });
                          widget.onInterestsChanged(selected.toList());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppBorderRadiusTokens.borderRadiusLarge,
                            ),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? AppColors.redRed500
                                      : AppColors.neutralGray400,
                            ),
                            color:
                                isSelected
                                    ? Colors.transparent
                                    : AppColors.neutralGray100,
                          ),
                          child: Text(
                            interest,
                            style: AppTheme.bodySmall12.copyWith(
                              color:
                                  isSelected
                                      ? AppColors.redRed500
                                      : AppColors.neutralGray800,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          ContinueButton(
            enabled: selected.isNotEmpty,
            onPressed: widget.onContinue,
          ),
        ],
      ),
    );
  }
}

class PhotoTab extends StatefulWidget {
  final VoidCallback onContinue;
  final Function(List<String>) onPhotosChanged;
  final List<String> initialPhotos;

  const PhotoTab({
    super.key,
    required this.onContinue,
    required this.onPhotosChanged,
    required this.initialPhotos,
  });

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab> {
  late List<String?> photos;

  @override
  void initState() {
    super.initState();
    // Initialize with existing photos if any, otherwise create empty slots
    photos =
        widget.initialPhotos.isNotEmpty
            ? List<String?>.from(widget.initialPhotos.map((p) => p).toList())
            : List.generate(6, (index) => null);

    // If the list is shorter than 6, pad it with nulls
    while (photos.length < 6) {
      photos.add(null);
    }
  }

  void _addPhoto(int index, String path) {
    setState(() {
      photos[index] = path;
      _updatePhotosList();
    });
  }

  void _removePhoto(int index) {
    setState(() {
      photos[index] = null;
      _updatePhotosList();
    });
  }

  void _updatePhotosList() {
    final nonNullPhotos =
        photos.where((p) => p != null).map((p) => p!).toList();
    widget.onPhotosChanged(nonNullPhotos);
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
            style: AppTheme.bodySmall12.copyWith(
              color: AppColors.neutralGray600,
            ),
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
                        borderRadius: BorderRadius.circular(
                          AppBorderRadiusTokens.borderRadiusMedium,
                        ),
                        color: AppColors.neutralGray200,
                      ),
                      alignment: Alignment.center,
                      child:
                          imagePath != null
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
                                    onImagePicked:
                                        (file) => _addPhoto(index, file.path),
                                  );
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: AppColors.redRed400,
                                ),
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
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          ContinueButton(
            enabled: selectedCount >= 2,
            onPressed: () {
              // Update photos list one final time
              _updatePhotosList();
              // Navigate to ready screen
              context.go('/ready');
            },
          ),
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
      borderRadius: BorderRadius.circular(
        AppBorderRadiusTokens.borderRadiusLarge,
      ),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration:
              enabled
                  ? AppDecoration.createAccountButton()
                  : BoxDecoration(
                    color: AppColors.neutralGray300,
                    borderRadius: BorderRadius.circular(
                      AppBorderRadiusTokens.borderRadiusLarge,
                    ),
                  ),
          alignment: Alignment.center,
          child: Text(
            'CONTINUE',
            style: AppTheme.titleSmall16.copyWith(
              color:
                  enabled ? AppColors.primaryWhite : AppColors.neutralGray600,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
