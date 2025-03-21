import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/house_tile.dart';

class HouseList extends StatefulWidget {
  HouseList({super.key});

  @override
  HouseListState createState() => HouseListState();
}

class HouseListState extends State<HouseList> {
  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF47804B),
        title: Text(
          'House Market',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: CupertinoButton(
          child: Icon(
            CupertinoIcons.line_horizontal_3,
            color: Colors.white,
            size: 8.sp,
          ),
          onPressed: () {},
        ),
        actions: [
          CupertinoButton(
              child: Icon(
                CupertinoIcons.search,
                size: 8.sp,
                color: Colors.white,
              ),
              onPressed: (){
                //Aquí hacen que aparezca el search bar ;)
              }
          )
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
        child: ListView(
          // shrinkWrap: true,
          // scrollDirection: Axis.vertical,
          children: [
            //Aquí inluí los house tiles como dummy data con fotos aleatorias
            //Pueden seguir añadiendo rows con house tiles hacia abajo para hacer la página scrollable y jugar un poco 👍🏾


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HouseTile(imagePath: [
                  'assets/images/house1.jpg',
                  'assets/images/house2.jpg',
                  'assets/images/house3.jpg'
                ],
                    title: 'San Juan Villa', price: '\$100.00', details: 'Dummy Data', isFavorite: true),
                HouseTile(imagePath: [
                  'assets/images/house1.jpg',
                  'assets/images/house2.jpg',
                  'assets/images/house3.jpg'
                ],
                    title: 'San Juan Villa', price: '\$100.00', details: 'Dummy Data', isFavorite: false),
                HouseTile(imagePath: [
                  'assets/images/house1.jpg',
                  'assets/images/house2.jpg',
                  'assets/images/house3.jpg'
                ],
                    title: 'San Juan Villa', price: '\$100.00', details: 'Dummy Data', isFavorite: true)
              ],
            )
          ],
        ),
      ),
    );
  }
}
