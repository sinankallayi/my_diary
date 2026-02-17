import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../all_memories_screen.dart';
import '../../../services/supabase_service.dart';

class MemoriesSection extends StatefulWidget {
  const MemoriesSection({super.key});

  @override
  State<MemoriesSection> createState() => MemoriesSectionState();
}

class MemoriesSectionState extends State<MemoriesSection> {
  List<Map<String, dynamic>> _memories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    await _loadMemories();
  }

  Future<void> _loadMemories() async {
    setState(() => _isLoading = true);

    try {
      final entries = await SupabaseService().getAllDiaryEntries();
      final List<Map<String, dynamic>> loadedMemories = [];

      for (var entry in entries) {
        final date = DateTime.parse(entry['entry_date']);
        final text = entry['content'] ?? "";
        final List<dynamic> images = entry['images'] ?? [];

        if (text.isNotEmpty || images.isNotEmpty) {
          loadedMemories.add({
            'date': date,
            'text': text,
            'image': images.isNotEmpty ? images.first : null,
          });
        }
      }

      if (mounted) {
        setState(() {
          _memories = loadedMemories;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading memories: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: imageUrl.startsWith('http')
                  ? Image.network(imageUrl, fit: BoxFit.contain)
                  : Image.file(File(imageUrl), fit: BoxFit.contain),
            ),
            Positioned(
              top: 40.h,
              right: 20.w,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memoryCard(String date, String quote, String? imagePath) {
    return GestureDetector(
      onTap: () {
        if (imagePath != null) {
          _showImageDialog(imagePath);
        }
      },
      child: Container(
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
                    ),
                    child: imagePath == null
                        ? Center(
                            child: Icon(
                              Icons.article,
                              color: Colors.grey.shade400,
                              size: 40.sp,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r),
                                bottom: Radius.circular(20.r),
                              ),
                              image: DecorationImage(
                                image: imagePath.startsWith('http')
                                    ? NetworkImage(imagePath)
                                    : FileImage(File(imagePath))
                                          as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
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
      ),
    );
  }
}
