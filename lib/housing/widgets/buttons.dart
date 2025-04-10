import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../Classes/ListingService.dart';
import '../../Classes/LodgingClass.dart';

class EditButton extends StatelessWidget {
  final VoidCallback pressed;

  const EditButton({
    super.key,
    required this.pressed
  });


  @override
  Widget build(BuildContext context) {
      return ElevatedButton(
        onPressed: pressed,
        child: Text(
            "Edit",
            style: TextStyle(
              color: const Color(0xFF47804B),
              fontSize: 5.sp,
            )
        )
      );
  }
}

// The Create Listing button logic.
class CreateButton extends StatelessWidget {
  final VoidCallback pressed;

  const CreateButton({
    super.key,
    required this.pressed
  });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: pressed,

        child: Text(
            "Create a Listing",
            style: TextStyle(
              color: const Color(0xFF47804B),
              fontWeight: FontWeight.bold,
            )
        )
    );
  }
}
