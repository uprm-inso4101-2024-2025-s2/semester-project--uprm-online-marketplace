import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Represents a detailed page for a house listing.
/// Displays house information, an image slider, description, and a contact form.
/// The layout adapts to different screen sizes.
class HousePage extends StatefulWidget {
  final String title;
  final String price;
  final String location;
  final List<String> images;
  final String description;

  const HousePage({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.images,
    required this.description,
  });

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  /// Advances the image slider to the next image, if available.
  void _nextImage() {
    if (_currentPage < widget.images.length - 1) {
      setState(() {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  /// Moves the image slider to the previous image, if available.
  void _previousImage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: Colors.white, size: 8.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        // Adapts the layout based on available width.
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 800;
            return isWideScreen ? _buildWideLayout() : _buildNarrowLayout();
          },
        ),
      ),
    );
  }

  /// Constructs a layout optimized for wide screens.
  /// Arranges the image slider, description, and contact form side by side.
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSlider(),
              SizedBox(height: 16.h),
              Text(
                'House Description',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(widget.description, style: TextStyle(fontSize: 7.sp)),
            ],
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(flex: 2, child: _buildContactForm()),
      ],
    );
  }

  /// Constructs a layout optimized for narrow screens.
  /// Stacks the image slider, description, and contact form vertically.
  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageSlider(),
        SizedBox(height: 16.h),
        Text(
          'House Description',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(widget.description, style: TextStyle(fontSize: 16.sp)),
        SizedBox(height: 24.h),
        _buildContactForm(),
      ],
    );
  }

  /// Builds an image slider with navigation controls.
  /// Encapsulates the logic for displaying and navigating through house images.
  Widget _buildImageSlider() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: SizedBox(
            height: 300.h,
            width: double.infinity,
            child: PageView(
              controller: _pageController,
              children: widget.images.map((image) {
                return Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              }).toList(),
            ),
          ),
        ),
        if (_currentPage > 0)
          Positioned(
            left: 10.w,
            top: 130.h,
            child: GestureDetector(
              onTap: _previousImage,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18.r,
                child: Icon(Icons.chevron_left, color: Colors.black, size: 20.sp),
              ),
            ),
          ),
        if (_currentPage < widget.images.length - 1)
          Positioned(
            right: 10.w,
            top: 130.h,
            child: GestureDetector(
              onTap: _nextImage,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18.r,
                child: Icon(Icons.chevron_right, color: Colors.black, size: 20.sp),
              ),
            ),
          ),
      ],
    );
  }

  /// Renders a contact form within a card to allow inquiries about the listing.
  Widget _buildContactForm() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text(widget.price,
                style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            SizedBox(height: 8.h),
            Text('📍 ${widget.location}',
                style: TextStyle(fontSize: 6.sp, color: Colors.black54)),
            Divider(),
            Text('Contact Landlord',
                style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            _buildTextField('Your Name'),
            SizedBox(height: 10.h),
            _buildTextField('Your Message', maxLines: 3),
            SizedBox(height: 10.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF47804B),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onPressed: () {
                // Handle form submission (logic can be extended later).
              },
              child: Center(
                child: Text('Send Inquiry',
                    style: TextStyle(fontSize: 8.sp, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a reusable styled text field for user input.
  /// Supports customization such as label text and maximum lines.
  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }
}
