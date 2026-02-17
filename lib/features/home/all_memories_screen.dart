import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';

class AllMemoriesScreen extends StatefulWidget {
  const AllMemoriesScreen({super.key});

  @override
  State<AllMemoriesScreen> createState() => _AllMemoriesScreenState();
}

class _AllMemoriesScreenState extends State<AllMemoriesScreen> {
  List<Map<String, dynamic>> _memories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final List<Map<String, dynamic>> loadedMemories = [];

    for (String key in keys) {
      if (key.startsWith('diary_entry_')) {
        final dateString = key.replaceFirst('diary_entry_', '');
        try {
          final date = DateFormat('yyyy-MM-dd').parse(dateString);
          final text = prefs.getString(key) ?? "";

          List<String> images =
              prefs.getStringList('diary_images_$dateString') ?? [];
          if (images.isEmpty) {
            final singleImage = prefs.getString('diary_image_$dateString');
            if (singleImage != null) images.add(singleImage);
          }

          if (text.isNotEmpty || images.isNotEmpty) {
            loadedMemories.add({'date': date, 'text': text, 'images': images});
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.pink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "All Memories",
          style: AppTheme.serifTitleStyle.copyWith(
            color: AppColors.darkText,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            )
          : _memories.isEmpty
          ? Center(
              child: Text(
                "No memories found yet.",
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: _memories.length,
              itemBuilder: (context, index) {
                final memory = _memories[index];
                return _buildMemoryItem(memory);
              },
            ),
    );
  }

  Widget _buildMemoryItem(Map<String, dynamic> memory) {
    final date = memory['date'] as DateTime;
    final text = memory['text'] as String;
    final images = memory['images'] as List<String>;
    final dateStr = DateFormat('MMMM d, yyyy').format(date);
    final dayStr = DateFormat('EEEE').format(date);

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(16.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: TextStyle(
                  color: AppColors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                dayStr,
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (text.isNotEmpty)
            Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.darkText,
                height: 1.5,
              ),
            ),
          if (images.isNotEmpty) ...[
            SizedBox(height: 16.h),
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, imgIndex) {
                  return Container(
                    margin: EdgeInsets.only(right: 12.w),
                    width: 100.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: FileImage(File(images[imgIndex])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
