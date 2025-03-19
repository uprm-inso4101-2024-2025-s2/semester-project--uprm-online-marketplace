import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/house_page.dart';
import 'buttons.dart';
import '../pages/edit_listing.dart';

class HouseTile extends StatefulWidget {
  final List<String> imagePath;
  final String title;
  final String price;
  final String details;
  final bool isFavorite;
  final bool isActive;
  final VoidCallback onToggleStatus;

  const HouseTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.details,
    required this.isFavorite,
    required this.isActive,
    required this.onToggleStatus,
  });

  @override
  HouseTileState createState() => HouseTileState();
}

class HouseTileState extends State<HouseTile> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _nextImage() {
    if (_currentPage < widget.imagePath.length - 1) {
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
    return GestureDetector(
      // child: SizedBox(
      //   width: 400,
      //   height: 380, // Increased height to prevent overflow
      //   child: Card(
      //     color: Colors.white,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     elevation: 5,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //
      //         Stack(
      //           children: [
      //             ClipRRect(
      //               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      //               child: SizedBox(
      //                 width: 400,
      //                 height: 250,
      //                 child: PageView(
      //                   controller: _pageController,
      //                   children: widget.imagePath.map((imagePath) {
      //                     return Image.asset(
      //                       imagePath,
      //                       fit: BoxFit.cover,
      //                     );
      //                   }).toList(),
      //                 ),
      //               ),
      //             ),
      //             if (_currentPage > 0)
      //               Positioned(
      //                 left: 10,
      //                 top: 110,
      //                 child: GestureDetector(
      //                   onTap: _previousImage,
      //                   child: const CircleAvatar(
      //                     backgroundColor: Colors.white,
      //                     child: Icon(Icons.chevron_left, color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //             if (_currentPage < widget.imagePath.length - 1)
      //               Positioned(
      //                 right: 10,
      //                 top: 110,
      //                 child: GestureDetector(
      //                   onTap: _nextImage,
      //                   child: const CircleAvatar(
      //                     backgroundColor: Colors.white,
      //                     child: Icon(Icons.chevron_right, color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //
      //             Positioned(
      //               top: 10,
      //               right: 10,
      //               child: CircleAvatar(
      //                 backgroundColor: Colors.white,
      //                 child: Icon(
      //                   widget.isFavorite ? Icons.favorite : Icons.favorite_border,
      //                   color: widget.isFavorite ? Colors.red : Colors.black,
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HousePage(
              title: widget.title,
              price: widget.price,
              location: "Mayagüez, PR",
              images: widget.imagePath,
              description: "Spacious 3-bedroom house with modern amenities...",
            ),
          ),
        );
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 140.w, // ✅ Adjusted for compact design
            minHeight: 180.h, // ✅ Proper height
            maxHeight: 220.h, // ✅ Keeps structure intact
          ),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10.r),
                      ),
                      child: SizedBox(
                        height: 140.h, // ✅ Maintains proper image height
                        width: double.infinity,
                        child: PageView(
                          controller: _pageController,
                          children: widget.imagePath.map((imagePath) {
                            return Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (_currentPage > 0)
                      Positioned(
                        left: 5.w,
                        top: 50.h,
                        child: GestureDetector(
                          onTap: _previousImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 12.r,
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.black,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    if (_currentPage < widget.imagePath.length - 1)
                      Positioned(
                        right: 5.w,
                        top: 50.h,
                        child: GestureDetector(
                          onTap: _nextImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 12.r,
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 5.h,
                      right: 5.w,
                      child: GestureDetector(
                        onTap: () {
                          // Handle favorite toggle
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 12.r,
                          child: Icon(
                            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: widget.isFavorite ? Colors.red : Colors.black,
                            size: 8.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              Padding(
                // padding: const EdgeInsets.all(12),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      maxLines:1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.bold), //18 old size
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.price,
                          style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold), //16 old size
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.black, size: 6.sp), //18 old size
                            SizedBox(width: 2.w),
                            Text(
                              widget.details,
                              style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold), //14 old size
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible( // Ensures the text adapts to available space
                          child: Text(
                            widget.isActive ? "Active" : "Inactive",
                            style: TextStyle(
                              fontSize: 4.sp, //6
                              fontWeight: FontWeight.bold,
                              color: widget.isActive ? Colors.green : Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: 4.w), // Minimal spacing
                        Flexible(// Ensures button adapts to available space
                          child:ElevatedButton(
                            style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                          minimumSize: Size(45.w, 15.h), //50 20
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Tightens button size
                        ),
                        onPressed: widget.onToggleStatus,
                        child: FittedBox(
                          child: Text(
                            widget.isActive ? "Deactivate" : "Activate",
                            style: TextStyle(fontSize: 5.sp),
                          ),
                        ),
                       ),
                        ),
                        Flexible(
                          child: EditButton(
                            pressed:() {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (
                                  context) => const EditListingPage()
                              ),
                              );
                            }
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}



