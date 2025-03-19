import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../Classes/ListingService.dart';
import '../../Classes/LodgingClass.dart';

class CreateListingPage extends StatefulWidget{
  const CreateListingPage({Key? key}) : super(key:key);

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage>{
  //Accesses the Listing Service unique instance.
  ListingService listingService= ListingService();

  //Manages FocusNodes for disposal.
  final List<FocusNode> _focusNodes= [];
  //Allows user input storing.
  TextEditingController titleController= TextEditingController();
  TextEditingController locationController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController bedroomsController= TextEditingController();
  TextEditingController restroomsController= TextEditingController();
  TextEditingController parkingController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();

  //Allows image input storing.
  final List<String> _imageUrls= [];
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

  //Listing creation's main widget.
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF47804B),
          title: Text(
              "Creating Listing",
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
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 8.5.w),
                                  Column( //First Column
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:[
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF47804B),
                                                  ),
                                                  onPressed: (){
                                                    cancelConfirmation();;
                                                    setState(() {});
                                                  },
                                                  child: Text("Cancel",
                                                    style : TextStyle(color: Colors.white),
                                                  )
                                              ),
                                              SizedBox(width: 120.w),
                                            ]
                                        ),
                                        SizedBox(height: 10.h),
                                        _createImageDisplay(),
                                        SizedBox(height: 8.h),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children:[
                                              Container(height: 18.h, width: 47.w,
                                                  child: ElevatedButton(
                                                      onPressed: (){
                                                        removeCurrentImage();
                                                        setState(() {});
                                                      },
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
                                        SizedBox(height: 28.h),
                                      ]
                                  ),
                                  SizedBox(width: 1.5.w),
                                  Column( //Second Column
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 30.h),
                                        _createTextField("Description", maxLines: 3,
                                            width: 200.w,
                                            controller: descriptionController),
                                        Row( //This Row creates two columns for text boxes.
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
                                                  _createTextField("Parking Amount", width: 100.w,
                                                      controller: parkingController),
                                                ]
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 52.h),
                                        Row( //Creates the Save button on the bottom right corner.
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children:[
                                              SizedBox(width: 150.w),
                                              Container(
                                                  width: 40.w,
                                                  height: 35.h,
                                                  child: FloatingActionButton(
                                                    heroTag: "create_button",
                                                    backgroundColor: const Color(0xFF47804B),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.r),
                                                    ),
                                                    child: Text("CREATE",
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
                                                        createOwnListing();
                                                      }
                                                    },
                                                  )
                                              )
                                            ]
                                        ),
                                      ]
                                  ),
                                ]
                            ),
                          ]
                      ),
                    ),
                  )
              )
          )
      ),
    );
  }

  //Widget where data validation is handled, as well as various interactive
  //UI features.
  @override
  Widget _createTextField(String label, {int maxLines = 1,
    double width= double.infinity, TextEditingController? controller}) {
    FocusNode focusNode= FocusNode();
    _focusNodes.add(focusNode);
    return SizedBox(
      width: width,
      child:StatefulBuilder(
        builder: (context, setState){
          focusNode.addListener((){
            setState((){});
          });
          return TextFormField(
            controller: controller,
            maxLines: maxLines,
            focusNode: focusNode,

            //Data Validation
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
                else if(label=="Parking Amount"){
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

  //function that adds the input pictures into a list.
  Future<void> _pickImages() async{
    final List<XFile>? pickedFiles= await _picker.pickMultiImage();
    if(pickedFiles != null && pickedFiles.isNotEmpty){
      setState((){
        _imageUrls.addAll(pickedFiles.map((file) => file.path));
      });
    }
  }

  //This widget handles the Image logic.
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
    : Container(
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
                  "No images were found.",
                  style: TextStyle(color: Colors.white,)
              )
          )
      );
    }
  }

  //Will ask for confirmation if cancel button is hit.
  @override
  Future<void> cancelConfirmation() async{
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Are you sure you want to cancel?",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
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

  //Asks the user for confirmation before removing an image.
  @override
  Future<void> imageRemoveConfirmation() async{
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Are you sure you want to delete this image?",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
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
                    if(_currentPage>0) {
                      _currentPage--;
                    }else{
                      _currentPage=0;
                    }
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
  //Function uses validated input and creates a new instance of Listings.
  //Utilizing the ListingService
  @override
  void createOwnListing(){
    String title= titleController.text;
    double price= double.parse(priceController.text);
    String location= locationController.text;
    int bedrooms= int.parse(bedroomsController.text);
    int restrooms= int.parse(restroomsController.text);
    int parking= int.parse(parkingController.text);
    String description= descriptionController.text;
    List<String> imagesList= _imageUrls;

    Lodging newLodging= Lodging(owner: "DummyOwner", availability: "Available",
      title: title, price: price, location: location,
      condition: "DummyCondition", bedrooms: bedrooms, restrooms: restrooms,
      parking: parking, description: description, isActive: true,
      imageUrls: imagesList);
    listingService.createListing(newLodging);
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


