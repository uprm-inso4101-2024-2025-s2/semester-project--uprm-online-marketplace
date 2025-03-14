import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/house_page.dart';

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
    return Center(
      child: SizedBox(
        width: 400,
        height: 380, // Increased height to prevent overflow
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: SizedBox(
                      width: 400,
                      height: 250,
                      child: PageView(
                        controller: _pageController,
                        children: widget.imagePath.map((imagePath) {
                          return Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (_currentPage > 0)
                    Positioned(
                      left: 10,
                      top: 110,
                      child: GestureDetector(
                        onTap: _previousImage,
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.chevron_left, color: Colors.black),
                        ),
                      ),
                    ),
                  if (_currentPage < widget.imagePath.length - 1)
                    Positioned(
                      right: 10,
                      top: 110,
                      child: GestureDetector(
                        onTap: _nextImage,
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.chevron_right, color: Colors.black),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: widget.isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),


              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.price,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.black, size: 18),
                            Text(
                              widget.details,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: widget.isActive ? Colors.green : Colors.red,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: widget.onToggleStatus, // Toggle listing status callback
                          child: Text(widget.isActive ? "Deactivate" : "Activate"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../pages/house_page.dart';
//
// class HouseTile extends StatefulWidget {
//   final List<String> imagePath;
//   final String title;
//   final String price;
//   final String details;
//   final bool isFavorite;
//   final bool isActive;
//   final VoidCallback onToggleStatus;
//
//   const HouseTile({
//     super.key,
//     required this.imagePath,
//     required this.title,
//     required this.price,
//     required this.details,
//     required this.isFavorite,
//     required this.isActive,
//     required this.onToggleStatus,
//   });
//
//   @override
//   HouseTileState createState() => HouseTileState();
// }
//
// class HouseTileState extends State<HouseTile> {
//   late PageController _pageController;
//   int _currentPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }
//
//   void _nextImage() {
//     if (_currentPage < widget.imagePath.length - 1) {
//       setState(() {
//         _currentPage++;
//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       });
//     }
//   }
//
//   void _previousImage() {
//     if (_currentPage > 0) {
//       setState(() {
//         _currentPage--;
//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 140.w,
//           minHeight: 200.h,
//           maxHeight: 380.h,
//         ),
//         child: Card(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           elevation: 5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 250.h,
//                       child: PageView(
//                         controller: _pageController,
//                         children: widget.imagePath.map((imagePath) {
//                           return Image.asset(
//                             imagePath,
//                             fit: BoxFit.cover,
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                   if (_currentPage > 0)
//                     Positioned(
//                       left: 10.w,
//                       top: 110.h,
//                       child: GestureDetector(
//                         onTap: _previousImage,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.white,
//                           radius: 12.r,
//                           child: Icon(Icons.chevron_left, color: Colors.black),
//                         ),
//                       ),
//                     ),
//                   if (_currentPage < widget.imagePath.length - 1)
//                     Positioned(
//                       right: 10.w,
//                       top: 110.h,
//                       child: GestureDetector(
//                         onTap: _nextImage,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.white,
//                           radius: 12.r,
//                           child: Icon(Icons.chevron_right, color: Colors.black),
//                         ),
//                       ),
//                     ),
//                   Positioned(
//                     top: 10.h,
//                     right: 10.w,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       radius: 12.r,
//                       child: Icon(
//                         widget.isFavorite ? Icons.favorite : Icons.favorite_border,
//                         color: widget.isFavorite ? Colors.red : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               Padding(
//                 padding: EdgeInsets.all(12.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.title,
//                       style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 5.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           widget.price,
//                           style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.star, color: Colors.black, size: 14.sp),
//                             SizedBox(width: 2.w),
//                             Text(
//                               widget.details,
//                               style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           widget.isActive ? "Active" : "Inactive",
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.bold,
//                             color: widget.isActive ? Colors.green : Colors.red,
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: widget.onToggleStatus,
//                           child: Text(widget.isActive ? "Deactivate" : "Activate"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

