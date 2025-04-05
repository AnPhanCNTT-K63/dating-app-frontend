import 'package:flutter/material.dart';

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
    _tabController = TabController(length: 3, vsync: this); // 3 tab
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentTabIndex = _tabController.index;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('<'), // Tiêu đề là dấu <
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8), // Chiều cao của thanh tab
          child: Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(index); // Chuyển tab khi nhấn
                  },
                  child: Container(
                    height: 8,
                    color: _currentTabIndex == index
                        ? Colors.blue // Màu sáng cho tab đang chọn
                        : Colors.grey[300], // Màu mặc định cho tab không chọn
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NameTab(onContinue: _nextTab),
          BirthdayTab(onContinue: _nextTab),
          GenderTab(onContinue: _nextTab),
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
    return Center( // Căn giữa toàn bộ nội dung
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Cách hai bên màn hình 20 pixel
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My first name is',
              style: TextStyle(
                fontSize: 32, // Tăng kích thước chữ lên 32
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your first name',
                border: UnderlineInputBorder( // Chỉ sử dụng gạch chân
                  borderSide: BorderSide(
                    color: Colors.grey, // Màu gạch chân
                    width: 1.5, // Độ dày gạch chân
                  ),
                ),
                enabledBorder: UnderlineInputBorder( // Gạch chân khi không focus
                  borderSide: BorderSide(
                    color: Colors.grey, // Màu gạch chân
                    width: 1.5, // Độ dày gạch chân
                  ),
                ),
                focusedBorder: UnderlineInputBorder( // Gạch chân khi focus
                  borderSide: BorderSide(
                    color: Colors.blue, // Màu gạch chân khi focus
                    width: 2.0, // Độ dày gạch chân khi focus
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You have not approved in these regional variables for example.',
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                child: const Text('CONTINUE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My birthday is',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                hint: const Text('Month'),
                items: ['January', 'February', 'March'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {},
              ),
              DropdownButton<String>(
                hint: const Text('Day'),
                items: List.generate(31, (index) => (index + 1).toString()).map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {},
              ),
              DropdownButton<String>(
                hint: const Text('Year'),
                items: List.generate(124, (index) => (2024 - index).toString()).map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Your age will be stable.',
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              child: const Text('CONTINUE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenderTab extends StatelessWidget {
  final VoidCallback onContinue;

  const GenderTab({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'I am a',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            hint: const Text('Select your gender'),
            items: ['WOMAN', 'MAN'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {},
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              const Text('Privacy update on my paths'),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              child: const Text('CONTINUE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}