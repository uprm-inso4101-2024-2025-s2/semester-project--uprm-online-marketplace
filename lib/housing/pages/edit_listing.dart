import 'listings_creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../Classes/ListingService.dart';
import '../../Classes/LodgingClass.dart';

//This file will identify the user and extract the ID of the current Listing
//Being edited. Once the ID has been found, the controller variables will
//be reassigned to the most recent version of information of the Listing.
//The user can then modify any value they desire.


// The Create Listing button logic.

class EditListingPage extends StatefulWidget{
  const EditListingPage({Key? key}) : super(key:key);

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage>{
  //Accesses the Listing Service unique instance.
  ListingService listingService= ListingService();

  //Manages FocusNodes for disposal.
  final List<FocusNode> _focusNodes= [];
  TextEditingController titleController= TextEditingController();
  TextEditingController locationController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController bedroomsController= TextEditingController();
  TextEditingController restroomsController= TextEditingController();
  TextEditingController parkingController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();

  //Allows image input storing.
  List<String> _imageUrls= [];
  final ImagePicker _picker= ImagePicker();
  late PageController _pageController;
  int _currentPage=0;
  //Indicator that every input is valid before the creation of a Listing.
  final _formKey= GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
  }

  @override
  void updateControllers(){
    //Commented since use of dummy data to validate implementation is much simpler.
    // //Parameter will be a function that links the user with the Id of their accessed Listing.
    // Lodging? currListing= listingService.fetchListing(620001598);
    // if(currListing!=null){
    //   titleController.text= currListing.getTitle();
    //   locationController.text= currListing.getLocation();
    //   priceController.text= currListing.getPrice().toString();
    //   bedroomsController.text= currListing.getBedrooms().toString();
    //   restroomsController.text= currListing.getRestrooms().toString();
    //   parkingController.text= currListing.getParking().toString();
    //   descriptionController.text= currListing.getDescription();
    //   _imageUrls.clear();
    //   _imageUrls= currListing.getImageUrls();
    //
    titleController.text= "Edit Test";
      locationController.text= "Should show this information editing page.";
      priceController.text= '100.0';
      bedroomsController.text= '2';
      restroomsController.text= '4';
      parkingController.text= '0';
      descriptionController.text= "Hope it works.";
      _imageUrls.clear();
      _imageUrls= [];
      }


//The Main widget for the Editing Feature.
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: Text(
          "Editing Listing",
            style: TextStyle(
              color: Colors.white,
            )
          )
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Center(
          child: Card(
            elevation: 5.0,
            color: const Color(0xFFF7F2FA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 8.5.w),
                                Column(
                                  children:[
                                    SizedBox(height: 30.h),
                                    _createImageDisplay(),
                                    SizedBox(height: 5.5.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:[
                                        Container(height: 18.h, width: 47.w,
                                          child: ElevatedButton(
                                            onPressed: removeCurrentImage,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                              const Color(0xFF47804B),
                                            ),
                                            child: const Text(
                                              "Remove Image",
                                              style: TextStyle(
                                                color: Colors.white,
                                              )
                                            )
                                          )
                                        ),
                                        SizedBox(width:40.w),
                                        Container(height: 18.h, width: 45.w,
                                          child: ElevatedButton(
                                            onPressed: _pickImages,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF47804B),
                                            ),
                                              child: const Text(
                                                "Add Images",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )
                                              )
                                          )
                                        ),
                                      ]
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        onPressed: (){
                                          updateControllers();
                                          setState(() {});
                                        },
                                        child: Text("Load Information",
                                        style : TextStyle(color: Color(0xFF47804B))),
                                      )
                                    )
                                  ]
                                ),
                                SizedBox(width: 1.5.w),
                                Column(
                                  children: [
                                    //Decription Textbox creation
                                    SizedBox(height: 30.h),
                                    _createTextField("Description", maxLines: 3,
                                      width: 200.w,
                                      controller: descriptionController),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //Title, Price & Restrooms Textboxes Creation.
                                            SizedBox(height: 12.5.h),
                                            _createTextField("Title", width: 100.w,
                                              controller: titleController),
                                            SizedBox(height: 12.5.h),
                                            _createTextField("Price", width: 100.w,
                                              controller: priceController),
                                            SizedBox(height: 12.5.h),
                                            _createTextField("Restrooms", width: 100.w,
                                              controller: restroomsController),
                                          ],
                                        ),
                                        SizedBox(width: 1.5.w),
                                        //Location, Bedrooms, Parking TextBoxes Creation
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 12.5.h),
                                              _createTextField("Location", width: 100.w,
                                                controller: locationController),
                                              SizedBox(height: 12.5.h),
                                              _createTextField("Bedrooms", width: 100.w,
                                                controller: bedroomsController),
                                              SizedBox(height: 12.5.h),
                                              _createTextField("Parking", width: 100.w,
                                                controller: parkingController),
                                            ]
                                          )
                                      ],
                                    )
                                  ]
                                ),
                                      SizedBox(width: 5.w),
                              ]
                            ),
                          ]
                      ),
                        Positioned(
                          bottom: 10.h,
                          right: 10.w,
                          child: Container(
                            width: 40.w,
                            height: 35.h,
                            child: FloatingActionButton(
                              heroTag: "save_button",
                              backgroundColor: const Color(0xFF47804B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text("SAVE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )
                              ),
                              onPressed: (){
                                if(_imageUrls.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      backgroundColor: Color(0xFF47804B),
                                      content: Text(
                                        "Make sure you insert at least one Image.",
                                      style: TextStyle(color: Colors.white,))
                                    )
                                  );
                                }if(_formKey.currentState!.validate()) {
                                    modifyOwnListing();
                                }
                              },
                            )
                          )
                        ),
                        Positioned(
                          bottom: 10.h,
                          left: 10.w,
                          child: Container(
                            width: 40.w,
                            height: 35.h,
                            child: FloatingActionButton(
                              heroTag:"delete_button",
                              backgroundColor: const Color(0xFF47804B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text("DELETE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )
                              ),
                              onPressed: (){
                                listingRemovalConfirmation();
                                setState(() {});
                              },
                            )
                          )
                        )
                    ]
                  )
              )
            )
          )
        )
      ),
    );
  }

  @override
  Widget _createTextField(String label, {int maxLines = 1,
    double width= double.infinity, TextEditingController? controller}) {
      FocusNode focusNode= FocusNode();
      _focusNodes.add(focusNode);
      return SizedBox(
        width: width,
        child:StatefulBuilder(
          builder: (context, setState){
            focusNode.addListener( (){ setState((){});} );
            return TextFormField(
              controller: controller,
              maxLines: maxLines,
              focusNode: focusNode,

              //Most of Data Validation is Implemented Here
              validator: (value){
                String? input= controller?.text;
                if(label=="Title"){
                  if(input!=null){
                    if(input.trim().isNotEmpty){
                      return null;
                    }return "Insert valid title.";
                  }return "Insert valid title";

                }
                else if(label=="Price"){
                  if(input!=null) {
                    double? price= double.tryParse(input);
                    if (price!= null && price>0) {
                      return null;
                    }return "Insert valid price.";
                  }return "Insert valid price.";
                }else if(label=="Location"){
                  if(input!=null){
                    if(input.trim().isNotEmpty){
                      return null;
                    }return "Insert valid Location.";
                  }return "Insert valid Location.";
                }
                else if(label=="Restrooms"){
                  if(input!=null){
                    int? restroomAmount= int.tryParse(input);
                    if(restroomAmount!=null && restroomAmount>0){
                      return null;
                    }return "Insert valid amount.";
                  }return "Insert valid amount.";
                }
                else if(label=="Bedrooms"){
                  if(input!=null){
                    int? bedroomAmount= int.tryParse(input);
                    if(bedroomAmount!=null && bedroomAmount>0){
                      return null;
                    }return "Insert valid amount.";
                  }return "Insert valid amount.";
                }
                else if(label=="Parking"){
                  if(input!=null){
                    int? parkingAmount= int.tryParse(input);
                    if(parkingAmount!=null && parkingAmount>=0){
                      return null;
                    }return "Insert valid amount.";
                  }return "Insert valid amount.";
                }
                else if(label=="Description"){
                  return null;
                }
              },
              //Checks the value of the validator to then conclude if the Listing can be created.
              //Insert If statement
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: focusNode.hasFocus ?  Color(0xFF47804B) : Colors.black,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF47804B), width: 2.0)
                ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0)
                ),
              ),
            );
          },
        )
    );
  }

  Future<void> _pickImages() async{
    final List<XFile>? pickedFiles= await _picker.pickMultiImage();
    if(pickedFiles != null && pickedFiles.isNotEmpty){
      setState((){
        _imageUrls.addAll(pickedFiles.map((file) => file.path));
      });
    }
  }

  //Widget that handles the Images.
  Widget _createImageDisplay(){
    return _imageUrls.isEmpty ? Container(
      width: 150.w,
      height: 200.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(Icons.image, size:25.sp, color: Color(0xFF47804B))
    )
    :Container(
      width: 150.w,
      height:200.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _imageUrls.length,
            onPageChanged: (index){
              setState(() {
                _currentPage= index;
              });
            },
            itemBuilder: (context, index){
              return Image.network(
                _imageUrls[index],
                fit: BoxFit.cover,
              );
            },
          ),
          if(_currentPage > 0)
            Positioned(
              left:5.w,
              top: 80.h,
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
          if(_currentPage < _imageUrls.length-1)
            Positioned(
              right:5.w,
              top:80.h,
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
        ],
      ),
    );
  }

  @override
  void removeCurrentImage(){
    if(_imageUrls.isNotEmpty) {
      imageRemoveConfirmation();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Color(0xFF47804B),
          content: Text(
            "No images were found. ",
            style: TextStyle(color: Colors.white,)
          )
        )
      );
    }
  }

  //Asks for confirmation before removing a listing.
  @override
  Future<void> listingRemovalConfirmation() async{
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Are you sure you want to delete this image?",
            style: TextStyle(fontWeight: FontWeight.bold)),
          actions:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                TextButton(
                  onPressed: () =>Navigator.pop(context),
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.resolveWith((states){
                      if(states.contains(WidgetState.hovered)){
                        return Color.fromRGBO(255, 0, 0, 0.2);
                      }
                      return null;
                    })
                  ),
                  child: Text("Cancel",
                    style: TextStyle(color: Colors.red,),),
                ),
                SizedBox(width:100.w),
                TextButton(
                  onPressed: () {
                    listingService.deleteListing(1000000); //will delete the Listing
                    setState(() {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.resolveWith((states){
                      if(states.contains(WidgetState.hovered)){
                        return  Color.fromRGBO(71, 128, 75, 0.2);
                      }
                      return null;
                    })
                  ),
                  child: Text("Confirm",
                    style: TextStyle(color: Color(0xFF47804B))),
                ),
              ]
            ),
          ],
        );
      },
    );
  }

  //Will ask for comfirmation before removing an already added image.
  @override
  Future<void> imageRemoveConfirmation() async{
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Are you sure you want to delete this image?",
            style: TextStyle(fontWeight: FontWeight.bold)),
          actions:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  TextButton(
                    onPressed: () =>Navigator.pop(context),
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith((states){
                        if(states.contains(WidgetState.hovered)){
                          return Color.fromRGBO(255, 0, 0, 0.2);
                        }
                        return null;
                      })
                    ),
                    child: Text("Cancel",
                      style: TextStyle(color: Colors.red,),),
                  ),
                  SizedBox(width:100.w),
                  TextButton(
                    onPressed: () {
                      _imageUrls.removeAt(_currentPage);
                      _currentPage = 0;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith((states){
                        if(states.contains(WidgetState.hovered)){
                          return  Color.fromRGBO(71, 128, 75, 0.2);
                        }
                        return null;
                      })
                    ),
                    child: Text("Confirm",
                      style: TextStyle(color: Color(0xFF47804B))),
                  ),
                ]
            ),
          ],
        );
      },
    );
  }
  @override
  void _nextImage(){
    if(_currentPage < _imageUrls.length-1){
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

  @override
  void _previousImage(){
    if(_currentPage > 0){
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
  void modifyOwnListing(){
    String title= titleController.text;
    double price= double.parse(priceController.text);
    String location= locationController.text;
    int bedrooms= int.parse(bedroomsController.text);
    int restrooms= int.parse(restroomsController.text);
    int parking= int.parse(parkingController.text);
    String description= descriptionController.text;
    List<String> imagesList= _imageUrls;



    listingService.updateListing(620001598, title: title, price: price,
      location: location, condition: "DummyCondition", bedrooms: bedrooms,
      restrooms: restrooms, parking: parking, isActive: true,
      imageUrls: _imageUrls );
    Navigator.pop(context);
  }


  @override
  void dispose(){
    _imageUrls.clear();
    titleController.dispose();
    locationController.dispose();
    priceController.dispose();
    bedroomsController.dispose();
    restroomsController.dispose();
    parkingController.dispose();
    descriptionController.dispose();
    for(var focusNode in _focusNodes){
      focusNode.dispose();
    }
    super.dispose();
  }
}


