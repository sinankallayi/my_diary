import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../services/supabase_service.dart';

class WriteTodayCard extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback? onEntrySaved;

  const WriteTodayCard({
    super.key,
    required this.selectedDate,
    this.onEntrySaved,
  });

  @override
  State<WriteTodayCard> createState() => _WriteTodayCardState();
}

class _WriteTodayCardState extends State<WriteTodayCard> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = []; // Can be local paths or remote URLs
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
      final data = await SupabaseService().getDiaryEntry(widget.selectedDate);

      if (mounted) {
        setState(() {
          if (data != null) {
            _controller.text = data['content'] ?? '';
            _imagePaths = List<String>.from(data['images'] ?? []);
          }
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
    setState(() => _isLoading = true);

    try {
      List<String> finalImageUrls = [];

      // upload new images
      for (String path in _imagePaths) {
        if (path.startsWith('http')) {
          finalImageUrls.add(path);
        } else {
          // It's a local file, upload it
          final url = await SupabaseService().uploadDiaryImage(File(path));
          finalImageUrls.add(url);
        }
      }

      await SupabaseService().saveDiaryEntry(
        date: widget.selectedDate,
        content: _controller.text,
        imageUrls: finalImageUrls,
      );

      // Trigger callback to refresh other parts of the UI (e.g. Memories)
      widget.onEntrySaved?.call();

      // Update local state with the new URLs to reflect saved state
      if (mounted) {
        setState(() {
          _imagePaths = finalImageUrls;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Diary entry saved successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to save entry: $e")));
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSameDay(widget.selectedDate, DateTime.now())
                        ? "Write Today's Diary"
                        : "Write a Diary",
                    style: AppTheme.serifTitleStyle.copyWith(fontSize: 22.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(widget.selectedDate),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
                  final path = _imagePaths[index];
                  final isNetwork = path.startsWith('http');

                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12.w),
                        width: 120.h,
                        height: 120.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          image: DecorationImage(
                            image: isNetwork
                                ? NetworkImage(path) as ImageProvider
                                : FileImage(File(path)),
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
