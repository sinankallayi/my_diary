import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning, Sarah",
                        style: AppTheme.serifTitleStyle.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      Text(
                        "Thursday, October 24",
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
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20.r,
                      offset: Offset(0, 5.h),
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
                            fontSize: 22.sp,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors.pink,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: const Icon(
                            Icons.edit_note,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Capture your thoughts and feelings.",
                      style: AppTheme.serifTitleStyle.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.greyText,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: const Text(
                        "What's on your mind?",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: const Text("Write Now"),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // Calendar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "October 2024",
                    style: AppTheme.serifTitleStyle.copyWith(fontSize: 20.sp),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.chevron_left, color: Colors.grey),
                      SizedBox(width: 10.w),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Calendar Grid (Hardcoded for exact UI match)
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ["M", "T", "W", "T", "F", "S", "S"]
                          .map(
                            (e) => SizedBox(
                              width: 30.w,
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
                    SizedBox(height: 16.h),
                    _calendarRow(
                      ["20", "21", "22", "1", "2", "3", "4"],
                      [false, false, false, true, false, true, false],
                    ),
                    SizedBox(height: 16.h),
                    _calendarRow(
                      ["5", "6", "7", "8", "9", "10", "11"],
                      [false, true, false, false, false, true, false],
                    ),
                    SizedBox(height: 16.h),
                    _calendarRow(
                      ["12", "13", "14", "15", "16", "17", "18"],
                      [true, false, false, false, false, false, false],
                    ),
                    SizedBox(height: 16.h),
                    _calendarRow(
                      ["19", "20", "21", "22", "23", "24", "25"],
                      [false, false, false, false, false, false, false],
                      selectedIndex: 5,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // Memories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Memories",
                    style: AppTheme.serifTitleStyle.copyWith(fontSize: 20.sp),
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
              SizedBox(height: 16.h),
              SizedBox(
                height: 220.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    _memoryCard(
                      "Oct 12",
                      "The coffee today felt extra warm and comforting...",
                      "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80",
                    ),
                    SizedBox(width: 16.w),
                    _memoryCard(
                      "Oct 10",
                      "Walked through the park today. The leaves were...",
                      "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
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
          width: 35.w,
          height: 40.h,
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink.withOpacity(0.4),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
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
                SizedBox(height: 4.h),
                CircleAvatar(radius: 2.r, backgroundColor: AppColors.pink),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _memoryCard(String date, String quote, String imageUrl) {
    return Container(
      width: 160.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                      bottom: Radius.circular(20.r),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                      bottom: Radius.circular(20.r),
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
                  bottom: 12.h,
                  left: 12.w,
                  child: Text(
                    date,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0.w),
            child: Text(
              "\"$quote\"",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.serifTitleStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 12.sp,
                color: const Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
