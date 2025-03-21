import 'LodgingClass.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingService extends LodgingManagement{
//Identify the Listings as Maps to easily access the value based off
//the key (ID), value will be the lodging. This ensures duplicates are not
//created.

//Since LodgingManagement already has error handling implemented for these methods,
//this class will handle duplicates utilizing IDs.

//For now the listings will be utilizing the Lodging class, if the project were
//to expand and utilize other products, this value type might change.
  final Map<int, Lodging> listings= {};

  //Creates a singular instance of ListingService.
  static final ListingService _instance= ListingService._internal();
  //Private constructor to avoid instantiation from outside the class.
  ListingService._internal();
  //It works as a public constructor that provides the singular instance
  //to outer classes.
  factory ListingService(){
    return _instance;
  }

  @override
  Future<void> createListing(Lodging lodging) async{
    if(listings.containsKey(lodging.getID())){
      throw ArgumentError('No Duplicates Allowed.');
    }else{
      listings[lodging.getID()]= lodging;
      super.addLodging(lodging);

      //Adds to Firestore
      //gets a reference to the listings collection in firestore, .doc(id) tries to find a document that already has that id
      //.set() saves the lodging data in firestore, replacing the document if it already existed, if the doc didnt exist it just creates new one
      await FirebaseFirestore.instance.collection("listings").doc(lodging.getID().toString()).set(lodging.toFirestore());
      print("Added to Firestore: ${lodging.title}");
    }
  }

  // @override
  // List <Lodging> fetchListings(){
  //   return super.getLodgings();
  // }
  @override
  Future<List<Lodging>> fetchListings() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('listings').get();

    List<Lodging> fetchedListings = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Lodging.fromFirestore(data);
    }).toList();

    return fetchedListings;
  }


  // Lodging? fetchListing(int ID){
  //   if(listings.containsKey(ID)){
  //     if(findLodgingWithId(ID)!=null){
  //       return listings[ID];
  //     }else{
  //       throw ArgumentError("Item not Found.");
  //     }
  //   }else{
  //     throw ArgumentError("Item not Found.");
  //   }
  // }
  Future<Lodging?> fetchListing(int id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('listings').doc(id.toString()).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Lodging.fromFirestore(data);
    } else {
      return null; // Return null if the listing does not exist
    }
  }




  // Fetch all listings (active and inactive) by owner
  List<Lodging> fetchOwnerListings(String owner) {
    return super.getLodgings().where((lodging) => lodging.getOwner() == owner).toList();
  }

  @override
  Future<void> updateListing(int id, {String? title, String? condition,
    String? description, double? price, String? location,
    int? bedrooms, int? restrooms, int? parking, bool? isActive,List<String>? imageUrls}) async{
    if(!listings.containsKey(id)){
      throw ArgumentError("Item not Found.");
    }
    else{

      Lodging? newLodging= editLodging(
          id,
          newTitle: title,
          newCondition: condition,
          newDescription:description,
          newPrice: price,
          newLocation: location,
          newBedrooms: bedrooms,
          newRestrooms: restrooms,
          newParking: parking,
          newImageUrls: imageUrls,
      );
      if(newLodging!=null){
        listings[id]= newLodging;

        //Update in Firestore
        await FirebaseFirestore.instance.collection('listings').doc(id.toString()).update({
          if(title != null) "title" : title,
          if(condition != null) "condition" : condition,
          if(description != null) "description" : description,
          if(price != null) "price" : price,
          if(location != null) "location" : location,
          if(bedrooms != null) "bedrooms" : bedrooms,
          if(restrooms != null) "restrooms" : restrooms,
          if(parking != null) "parking" : parking,
          if(imageUrls != null) "imageUrls" : imageUrls,
        });
      }
    }
  }

  @override
  Future<void> deleteListing(int id) async{
    if(listings.containsKey(id)) {
      Lodging? lodging = findLodgingWithId(id);
      if(lodging!=null){
        deleteLodging(lodging, id);
        listings.remove(id);

        //Delete from firestore
        await FirebaseFirestore.instance.collection('listings').doc(id.toString()).delete();
        // print("Deleted $id");
      }else{
        throw ArgumentError("Item does not exist.");
      }

    }else{
      throw ArgumentError("Item does not exist.");
    }
  }

  @override
  Future<void> clearListing() async{

    //Clear all documents from listings collection in firestore
    var collection = FirebaseFirestore.instance.collection('listings');
    var snapshots = await collection.get();
    for(var doc in snapshots.docs){
      await doc.reference.delete();
    }
    listings.clear();
    clearLodgings();
  }

  // Toggle active/inactive status of a listing
  void toggleListingStatus(int id, bool isActive) {
    if (listings.containsKey(id)) {
      listings[id]?.setStatus(isActive);
      print("Listing with ID $id is now ${isActive ? 'Active' : 'Inactive'}");
    } else {
      throw ArgumentError("Listing not found.");
    }
  }

}