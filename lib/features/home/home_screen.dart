import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/memories_section.dart';
import 'widgets/write_today_card.dart';
import '../profile/profile_setup_screen.dart';
import '../settings/settings_screen.dart';
import '../../services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  String? _profileImageUrl;
  String _userName = "Friend";
  String _greeting = "Good Morning";
  String _currentDate = "";

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<DateTime> _diaryDates = [];

  // Key to access MemoriesSection state for refreshing
  final GlobalKey<MemoriesSectionState> _memoriesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _updateTimeAndDate();
    _loadDiaryDates();
  }

  Future<void> _loadUserData() async {
    final profile = await SupabaseService().getProfile();
    if (mounted && profile != null) {
      setState(() {
        if (profile['full_name'] != null) {
          _userName = profile['full_name'];
        }
        if (profile['avatar_url'] != null) {
          _profileImageUrl = profile['avatar_url'];
        }
      });
    }
  }

  Future<void> _loadDiaryDates() async {
    final dates = await SupabaseService().getDiaryDates();
    if (mounted) {
      setState(() {
        _diaryDates = dates;
      });
    }
  }

  void _updateTimeAndDate() {
    final now = DateTime.now();
    final hour = now.hour;

    String greeting;
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    setState(() {
      _greeting = greeting;
      _currentDate = DateFormat('EEEE, MMMM d').format(now);
    });
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSetupScreen(
                        onComplete: () {
                          Navigator.pop(context);
                        },
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                  );
                  _loadUserData(); // Refresh user data on return
                },
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : const NetworkImage(
                              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
                            )
                            as ImageProvider,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$_greeting, $_userName",
                    style: AppTheme.serifTitleStyle.copyWith(fontSize: 18.sp),
                  ),
                  Text(
                    _currentDate,
                    style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 20.sp,
                  color: const Color(0xFF5C6E8C),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Write Today Card
          WriteTodayCard(
            selectedDate: _selectedDay,
            onEntrySaved: () {
              // Refresh memories
              _memoriesKey.currentState?.refresh();
              // Refresh calendar dots
              _loadDiaryDates();
            },
          ),
          SizedBox(height: 20.h),

          // Calendar Section
          CalendarWidget(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            eventDates: _diaryDates,
            onDaySelected: (day) {
              setState(() {
                _selectedDay = day;
                _focusedDay = DateTime(day.year, day.month);
                // _currentDate remains fixed to "Today" regardless of selection
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),

          SizedBox(height: 30.h),

          // Memories Section
          MemoriesSection(key: _memoriesKey),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(child: Text(title, style: AppTheme.serifTitleStyle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _bottomNavIndex,
          children: [
            _buildHomeContent(),
            _buildPlaceholder("Explore"),
            _buildPlaceholder("Archive"),
            const SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.pink,
        unselectedItemColor: const Color(0xFFA0A0B0),
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10.sp,
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
}
