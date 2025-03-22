import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesterprojectuprmonlinemarketplace/housing/pages/house_listing.dart';
import '../pages/house_page.dart';
import 'buttons.dart';
import '../pages/edit_listing.dart';
import '../../Classes/ListingService.dart';

/// A card-style widget that displays a house listing with images, price, and details.
/// Tapping the tile navigates to the HousePage.
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
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isFavorite = widget.isFavorite;
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HousePage(
              title: widget.title,
              price: widget.price,
              location: "Mayag\u00fcez, PR",
              images: widget.imagePath,
              description: "Spacious 3-bedroom house with modern amenities...",
            ),
          ),
        );
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 140.w,
            minHeight: 180.h,
            maxHeight: 220.h,
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
                        height: 140.h,
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
                      child: IconButton.filled(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.black,
                        ),
                        style: IconButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () {
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
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.price,
                            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.black, size: 6.sp),
                              SizedBox(width: 2.w),
                              Text(
                                widget.details,
                                style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.isActive ? "Active" : "Inactive",
                              style: TextStyle(
                                fontSize: 4.sp,
                                fontWeight: FontWeight.bold,
                                color: widget.isActive ? Colors.green : Colors.red,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                minimumSize: Size(45.w, 15.h),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                              pressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EditListingPage()),
                                );
                              },
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
