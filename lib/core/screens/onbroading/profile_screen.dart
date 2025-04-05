import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';

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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() => _currentTabIndex = _tabController.index));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextTab() {
    if (_currentTabIndex < 2) {
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
          icon: Icon(_currentTabIndex == 0 ? Icons.close : Icons.arrow_back, color: Colors.grey),
          onPressed: () => _currentTabIndex == 0 ? context.go('/') : _prevTab(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  color: _currentTabIndex >= index ? Colors.pink : Colors.grey[300],
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
          GenderTab(onContinue: () => context.go('/home')),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My first name is', style: AppTheme.headLineLarge32),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter your first name',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'This is how it will appear in Tinder and you will not be able to change it',
            style: AppTheme.bodySmall12.copyWith(color: Colors.grey),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My birthday is', style: AppTheme.headLineLarge32),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
              LengthLimitingTextInputFormatter(10),
              TextInputFormatter.withFunction((oldValue, newValue) {
                String text = newValue.text;
                if (text.length == 4 || text.length == 7) {
                  if (!text.endsWith('/')) {
                    text += '/';
                  }
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
          const SizedBox(height: 10),
          Text('Your age will be public', style: AppTheme.bodySmall12.copyWith(color: Colors.grey)),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('I am a', style: AppTheme.headLineLarge32),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('WOMAN'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('MAN'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(value: showGender, onChanged: (value) => setState(() => showGender = value!)),
              const Text('Show my gender on my profile')
            ],
          ),
          const Spacer(),
          ContinueButton(enabled: true, onPressed: widget.onContinue),
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
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: enabled
              ? AppDecoration.createAccountButton()
              : BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            'CONTINUE',
            style: AppTheme.titleSmall16.copyWith(
              color: enabled ? Colors.white : Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}