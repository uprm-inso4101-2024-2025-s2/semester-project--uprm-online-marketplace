import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesterprojectuprmonlinemarketplace/housing/pages/house_listing.dart';

class HousePage extends StatefulWidget {
  final String title;
  final String price;
  final String location;
  final List<String> images;
  final String description;
  final bool isFavorite;

  const HousePage({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.images,
    required this.description,
    required this.isFavorite,
  });

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  late PageController _pageController;
  int _currentPage = 0;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isFavorite = widget.isFavorite;
  }

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
          "House Market",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 800;
            return isWideScreen
                ? _buildWideLayout()
                : _buildNarrowLayout();
          },
        ),
      ),
    );
  }

  /// **Wide Screen Layout**
  Widget _buildWideLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Listing images
        _buildImageSlider(),
        SizedBox(height: 16.h), // spacing

        // Title and icons (favorite, location, message)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Color(0xFF212529) ,
                    ),
                    tooltip: "Add to favorites",
                    onPressed: (){
                      setState(() {
                        _isFavorite = !_isFavorite;
                        for (int i = 0; i < globalHouses.length; i++) {
                            if (widget.title == globalHouses[i]["title"]) {
                              globalHouses[i]["isFavorite"] = _isFavorite;
                            }
                          }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on_outlined),
                    tooltip: "View location on map",
                    onPressed: (){},
                  ),
                  IconButton(
                    icon: const Icon(Icons.sms_outlined),
                    tooltip: "Message seller",
                    onPressed: (){},
                  ),
                ],
              )
          ],
        ),

        // Price and location
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: <Widget>[
            Text(widget.price, style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold, color: Colors.green)),
            Text(widget.location, style: TextStyle(fontSize: 6.sp, color: Colors.black54)),
            Divider(),
          ],
        ),
        SizedBox(height: 4.h), // spacing

        // Author icon, name, and listing creation date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 5.sp,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0xffE6E6E6),
                  radius: 8.sp,
                  child: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 145, 145, 145),
                  ),
                ),
                Text("Juan del Pueblo", style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold),)
              ],
            ),
            Text("12/12/2012", style: TextStyle(fontSize: 6.sp)),
          ],
        ),

        // Description
        SizedBox(height: 6.h), // spacing
        Text(widget.description, style: TextStyle(fontSize: 7.sp)),
        SizedBox(height: 24.h),
      ],
    );
  }

  /// **Narrow Screen Layout**
  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Listing images
        _buildImageSlider(),
        SizedBox(height: 16.h), // spacing

        // Title and icons (favorite, location, message)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Color(0xFF212529) ,
                    ),
                    tooltip: "Add to favorites",
                    onPressed: (){
                      setState(() {
                        _isFavorite = !_isFavorite;
                        for (int i = 0; i < globalHouses.length; i++) {
                            if (widget.title == globalHouses[i]["title"]) {
                              globalHouses[i]["isFavorite"] = _isFavorite;
                            }
                          }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on_outlined),
                    tooltip: "View location on map",
                    onPressed: (){},
                  ),
                  IconButton(
                    icon: const Icon(Icons.sms_outlined),
                    tooltip: "Message seller",
                    onPressed: (){},
                  ),
                ],
              )
          ],
        ),

        // Price and location
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: <Widget>[
            Text(widget.price, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.green)),
            Text(widget.location, style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
            Divider(),
          ],
        ),
        SizedBox(height: 4.h), // spacing

        // Author icon, name, and listing creation date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10.sp,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0xffE6E6E6),
                  radius: 16.sp,
                  child: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 145, 145, 145),
                  ),
                ),
                Text("Juan del Pueblo", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),)
              ],
            ),
            Text("12/12/2012", style: TextStyle(fontSize: 10.sp)),
          ],
        ),

        // Description
        SizedBox(height: 6.h), // spacing
        Text(widget.description, style: TextStyle(fontSize: 12.sp)),
        SizedBox(height: 24.h), // spacing
      ],
    );
  }

  /// **Image Slider with Navigation**
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
                return Image.asset(image, fit: BoxFit.cover, width: double.infinity);
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

  /// **Contact Form for Landlord Inquiry**
  // Widget _buildContactForm() {
  //   return Card(
  //     elevation: 5,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
  //     child: Padding(
  //       padding: EdgeInsets.all(16.w),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(widget.title, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
  //           SizedBox(height: 8.h),
  //           Text(widget.price, style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold, color: Colors.green)),
  //           SizedBox(height: 8.h),
  //           Text('📍 ${widget.location}', style: TextStyle(fontSize: 6.sp, color: Colors.black54)),
  //           Divider(),
  //           Text('Contact Landlord', style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold)),
  //           SizedBox(height: 8.h),
  //           _buildTextField('Your Name'),
  //           SizedBox(height: 10.h),
  //           _buildTextField('Your Message', maxLines: 3),
  //           SizedBox(height: 10.h),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color(0xFF47804B),
  //               padding: EdgeInsets.symmetric(vertical: 12.h),
  //             ),
  //             onPressed: () {
  //               // Handle form submission
  //             },
  //             child: Center(
  //               child: Text('Send Inquiry', style: TextStyle(fontSize: 8.sp, color: Colors.white)),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// **Reusable TextField Widget**
  // Widget _buildTextField(String label, {int maxLines = 1}) {
  //   return TextField(
  //     maxLines: maxLines,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
  //     ),
  //   );
  // }
}