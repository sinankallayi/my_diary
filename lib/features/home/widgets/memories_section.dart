import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../all_memories_screen.dart';

class MemoriesSection extends StatefulWidget {
  const MemoriesSection({super.key});

  @override
  State<MemoriesSection> createState() => _MemoriesSectionState();
}

class _MemoriesSectionState extends State<MemoriesSection> {
  List<Map<String, dynamic>> _memories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final List<Map<String, dynamic>> loadedMemories = [];

    for (String key in keys) {
      if (key.startsWith('diary_entry_')) {
        final dateString = key.replaceFirst('diary_entry_', '');
        try {
          final date = DateFormat('yyyy-MM-dd').parse(dateString);
          final text = prefs.getString(key) ?? "";

          // Try to get images (list) or legacy single image
          List<String> images =
              prefs.getStringList('diary_images_$dateString') ?? [];
          if (images.isEmpty) {
            final singleImage = prefs.getString('diary_image_$dateString');
            if (singleImage != null) images.add(singleImage);
          }

          if (text.isNotEmpty || images.isNotEmpty) {
            loadedMemories.add({
              'date': date,
              'text': text,
              'image': images.isNotEmpty ? images.first : null,
            });
          }
        } catch (e) {
          debugPrint("Error parsing date from key $key: $e");
        }
      }
    }

    // Sort by date descending (newest first)
    loadedMemories.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    if (mounted) {
      setState(() {
        _memories = loadedMemories;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink(); // Or a loader
    }

    if (_memories.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            "Start writing to see your memories here.",
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "My Memories",
                  style: AppTheme.serifTitleStyle.copyWith(fontSize: 20.sp),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: _loadMemories,
                  child: Icon(
                    Icons.refresh,
                    size: 18.sp,
                    color: AppColors.pink,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllMemoriesScreen(),
                  ),
                );
                _loadMemories(); // Refresh on return
              },
              child: const Text(
                "View all",
                style: TextStyle(
                  color: AppColors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: _memories.length,
            itemBuilder: (context, index) {
              final memory = _memories[index];
              final date = memory['date'] as DateTime;
              final dateStr = DateFormat('MMM d').format(date);
              final text = memory['text'] as String;
              final imagePath = memory['image'] as String?;

              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: _memoryCard(dateStr, text, imagePath),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _memoryCard(String date, String quote, String? imagePath) {
    return Container(
      width: 160.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
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
                    color: Colors.grey.shade200, // Placeholder color
                    image: imagePath != null
                        ? DecorationImage(
                            image: FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imagePath == null
                      ? Center(
                          child: Icon(
                            Icons.article,
                            color: Colors.grey.shade400,
                            size: 40.sp,
                          ),
                        )
                      : null,
                ),
                if (imagePath != null)
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
                      color: imagePath != null
                          ? Colors.white
                          : AppColors.darkText,
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
              quote.isNotEmpty ? "\"$quote\"" : "\"No text entry\"",
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
