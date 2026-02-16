import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning, Sarah",
                        style: AppTheme.serifTitleStyle.copyWith(fontSize: 18),
                      ),
                      const Text(
                        "Thursday, October 24",
                        style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: Color(0xFF5C6E8C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Write Today Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Write Today's Diary",
                          style: AppTheme.serifTitleStyle.copyWith(
                            fontSize: 22,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.pink,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.edit_note,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Capture your thoughts and feelings.",
                      style: AppTheme.serifTitleStyle.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.greyText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "What's on your mind?",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Write Now"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Calendar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "October 2024",
                    style: AppTheme.serifTitleStyle.copyWith(fontSize: 20),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.chevron_left, color: Colors.grey),
                      SizedBox(width: 10),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Calendar Grid (Hardcoded for exact UI match)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ["M", "T", "W", "T", "F", "S", "S"]
                          .map(
                            (e) => SizedBox(
                              width: 30,
                              child: Center(
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFA0A0B0),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    _calendarRow(
                      ["20", "21", "22", "1", "2", "3", "4"],
                      [false, false, false, true, false, true, false],
                    ),
                    const SizedBox(height: 16),
                    _calendarRow(
                      ["5", "6", "7", "8", "9", "10", "11"],
                      [false, true, false, false, false, true, false],
                    ),
                    const SizedBox(height: 16),
                    _calendarRow(
                      ["12", "13", "14", "15", "16", "17", "18"],
                      [true, false, false, false, false, false, false],
                    ),
                    const SizedBox(height: 16),
                    _calendarRow(
                      ["19", "20", "21", "22", "23", "24", "25"],
                      [false, false, false, false, false, false, false],
                      selectedIndex: 5,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Memories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Memories",
                    style: AppTheme.serifTitleStyle.copyWith(fontSize: 20),
                  ),
                  const Text(
                    "View all",
                    style: TextStyle(
                      color: AppColors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    _memoryCard(
                      "Oct 12",
                      "The coffee today felt extra warm and comforting...",
                      "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80",
                    ),
                    const SizedBox(width: 16),
                    _memoryCard(
                      "Oct 10",
                      "Walked through the park today. The leaves were...",
                      "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.pink,
        unselectedItemColor: const Color(0xFFA0A0B0),
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "EXPLORE"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: "ARCHIVE",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "SETTINGS",
          ),
        ],
      ),
    );
  }

  Widget _calendarRow(
    List<String> days,
    List<bool> hasDot, {
    int selectedIndex = -1,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        bool isSelected = index == selectedIndex;
        bool showDot = hasDot[index];
        return Container(
          width: 35,
          height: 40,
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                days[index],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.darkText,
                ),
              ),
              if (showDot && !isSelected) ...[
                const SizedBox(height: 4),
                const CircleAvatar(radius: 2, backgroundColor: AppColors.pink),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _memoryCard(String date, String quote, String imageUrl) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "\"$quote\"",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.serifTitleStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: const Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
