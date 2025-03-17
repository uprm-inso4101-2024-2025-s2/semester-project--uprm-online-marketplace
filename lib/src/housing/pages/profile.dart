import '/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // Add this for TextInputFormatter
import '../../../services/auth_services.dart';
import 'profile_edit_userdetails.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF47804B), // Green color
        title: Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 300.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 55),
            Text('My Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              width: 120, height:120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  color: Colors.grey,
                ),
              )
            ),

            SizedBox(height: 18),
            Text('Justin Rivera Colon Maldonado', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            const Divider(thickness: 1, height: 16, endIndent: 700),
            SizedBox(height: 8),
            Text('Email: xd7jjjlove@gmail.com', style: TextStyle(fontSize: 20)),
            const Divider(thickness: 1, height: 16, endIndent: 700),
            SizedBox(height: 8),
            Text('Phone Number: 939-878-3451', style: TextStyle(fontSize: 20)),
            const Divider(thickness: 1, height: 16, endIndent: 700),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => ProfileScreen()),); //takes u to the userdetails update page
              },
              child: Text('Update User Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF47804B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),

              ),
            ),
            SizedBox(height:16),
            ElevatedButton(
              onPressed: () {}, // add functionality later
              child: Text('Saved Properties'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF47804B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height:16),
            ElevatedButton(
              onPressed: () {}, // add functionality later
              child: Text('Listed Properties'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF47804B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

















