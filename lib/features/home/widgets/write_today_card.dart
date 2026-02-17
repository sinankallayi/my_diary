import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

class WriteTodayCard extends StatefulWidget {
  final DateTime selectedDate;
  const WriteTodayCard({super.key, required this.selectedDate});

  @override
  State<WriteTodayCard> createState() => _WriteTodayCardState();
}

class _WriteTodayCardState extends State<WriteTodayCard> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  @override
  void didUpdateWidget(covariant WriteTodayCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!isSameDay(oldWidget.selectedDate, widget.selectedDate)) {
      _loadEntry();
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadEntry() async {
    setState(() {
      _isLoading = true;
      _controller.clear();
      _imagePaths = [];
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

      final savedEntry = prefs.getString('diary_entry_$dateKey');
      final savedImages = prefs.getStringList('diary_images_$dateKey');

      if (mounted) {
        setState(() {
          if (savedEntry != null) _controller.text = savedEntry;
          if (savedImages != null) _imagePaths = savedImages;
        });
      }
    } catch (e) {
      debugPrint("Error loading entry: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _imagePaths.addAll(images.map((e) => e.path));
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  Future<void> _saveEntry() async {
    // Allow saving empty text if there are images, or empty images if there is text.
    // If both are empty, we effectively "delete" the entry or just do nothing.
    // But user might want to delete by clearing everything.

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

      if (_controller.text.isEmpty) {
        await prefs.remove('diary_entry_$dateKey');
      } else {
        await prefs.setString('diary_entry_$dateKey', _controller.text);
      }

      if (_imagePaths.isEmpty) {
        await prefs.remove('diary_images_$dateKey');
      } else {
        await prefs.setStringList('diary_images_$dateKey', _imagePaths);
      }

      // Also remove single image legacy key if it exists to clean up
      await prefs.remove('diary_image_$dateKey');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Diary entry saved successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to save entry.")));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: AppTheme.serifTitleStyle.copyWith(fontSize: 22.sp),
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.pink,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                  ),
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

          if (_imagePaths.isNotEmpty) ...[
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12.w),
                        width: 120.h,
                        height: 120.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          image: DecorationImage(
                            image: FileImage(File(_imagePaths[index])),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4.h,
                        right: 16.w,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
          ],

          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 4,
              minLines: 1,
              decoration: const InputDecoration.collapsed(
                hintText: "What's on your mind?",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(fontSize: 14.sp, color: AppColors.darkText),
            ),
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Save Entry"),
            ),
          ),
        ],
      ),
    );
  }
}
