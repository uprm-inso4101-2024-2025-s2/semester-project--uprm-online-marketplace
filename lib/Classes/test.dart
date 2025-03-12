import 'LodgingClass.dart';
import 'ListingService.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//LodgingClass Tester (uncomment to use)
//////////////////////////////////////////////////////////////////
// void main(){
//   LodgingManagement lodgingManager = LodgingManagement();
//   Lodging testLodging = Lodging(g
//     owner: "Michael",
//     availability: "true",
//     price: 1200,
//     location: "Downtown",
//     condition: "Good",
//     bedrooms: 3,
//     restrooms: 2,
//     parking: 1,
//     description: "Spacious apartment",
//     title: "Apartment"
//   );

//   // print(testLodging is Product); //Should print true

//   print(testLodging.getOwner()); //Michael
//   print(testLodging.getAvailability()); //true
//   print(testLodging.getPrice()); //1200
//   print(testLodging.getLocation()); //Downtown
//   print(testLodging.getCondition()); //Good
//   print(testLodging.getBedrooms()); //3
//   print(testLodging.getRestrooms()); //2
//   print(testLodging.getParking()); //1
//   print(testLodging.getDescription()); //Spacious apartment
//   print(testLodging.getTitle()); //Apartment
//   print(testLodging.getID()); //Random Numbers

//   // Add and find lodging
//   lodgingManager.addLodging(testLodging);
//   print(lodgingManager.findLodgingWithId(testLodging.getID()) != null ? "Add & Find Test Passed" : "Add & Find Test Failed");

//   // Prevent invalid lodging (negative price)
//   try {
//     lodgingManager.addLodging(Lodging(owner: "John", availability: "true", price: -500, title: "Bad"));
//     print("Invalid Price Test Failed");
//   } catch (e) {
//     print("Invalid Price Test Passed");
//   }

//   // Edit and delete lodging
//   int id = testLodging.getID();
//   lodgingManager.editLodging(id, newPrice: 1500);
//   print(lodgingManager.findLodgingWithId(id)?.price == 1500 ? "Edit Test Passed" : "Edit Test Failed");

//   lodgingManager.deleteLodging(testLodging, id);
//   print(lodgingManager.findLodgingWithId(id) == null ? "Delete Test Passed" : "Delete Test Failed"); //look at deleteLodging function in LodgingClass.dart
// }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyCMjGDzcOQI1b9i8KVz87Z0qCBb9NX93_0",
    authDomain: "online-marketplace-posting.firebaseapp.com",
    projectId: "online-marketplace-posting",
    storageBucket: "online-marketplace-posting.firebasestorage.app",
    messagingSenderId: "436131107360",
    appId: "1:436131107360:web:d65c474f32ce843c55a245",
    measurementId: "G-13TKBZ7EG8"
);


//ListingService Tester (uncomment to use)

void main() async{

  //initialize firebase for testing
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);

  ListingService listingService = ListingService();

  Lodging lodging1 = Lodging(
    owner: 'Owner1',
    availability: 'Available',
    title: 'Lodging 1',
    price: 1000,
    location: 'Location 1',
    condition: 'Good',
    bedrooms: 2,
    restrooms: 1,
    parking: 1,
  );

  Lodging lodging2 = Lodging(
    owner: "Owner2",
    availability: 'Not Available',
    title: 'Lodging 2',
    price: 1500,
    location: 'Location2',
    condition: 'Excellent',
    bedrooms: 3,
    restrooms: 2,
    parking: 2,
  );

  // Test creating a listing
  print("🔵 Creating listing...");
  await listingService.createListing(lodging1);
  print(await listingService.fetchListings().length); // Expects 1
  print(await listingService.fetchListings().first.title); // Expects 'Lodging 1'

  await listingService.clearListing();

  // Test fetching listings
  print("🔵 Fetching listings...");
  await listingService.createListing(lodging1);
  await listingService.createListing(lodging2);
  List<Lodging> listings = await listingService.fetchListings();
  print(listings.length); // Expects 2
  print(listings[0].title); // Expects 'Lodging 1'
  print(listings[1].title); // Expects 'Lodging 2'
  await listingService.clearListing();

  // Test updating a listing
  print("🔵 Updating a listing...");
  await listingService.createListing(lodging1);
  await listingService.updateListing(lodging1.getID(), title: 'Updated Lodging 1', price: 1200);
  Lodging updatedLodging = (await listingService.fetchListings())
      .firstWhere((lodging) => lodging.getID() == lodging1.getID());
  print(updatedLodging.title); // Expects 'Updated Lodging 1'
  print(updatedLodging.price); // Expects 1200
  // await listingService.clearListing();

  // Test deleting a listing
  // print("🔵 Deleting a listing...");
  // await listingService.createListing(lodging1);
  // await listingService.createListing(lodging2);
  // await listingService.deleteListing(lodging1.getID());
  // print(await listingService.fetchListings().length); // Expects 1
  // print(await listingService.fetchListings().first.title); // Expects 'Lodging 2'
  // await listingService.clearListing();

  // Test fetching a lodging by ID
  // print("🔵 Fetching a lodging by ID...");
  // await listingService.createListing(lodging1);
  // final fetchedLodging = await listingService.fetchLodging(lodging1.getID());
  // print(fetchedLodging?.title); // Expects 'Lodging 1'
  // print(fetchedLodging?.price); // Expects 1000
  // print(fetchedLodging?.location); // Expects 'Location 1'

  // Uncomment these lines for additional tests
  // Test fetching a non-existent lodging (should throw an error)
  // await listingService.fetchLodging(99999999);

  // Test duplicate listings (should throw an error)
  // await listingService.createListing(lodging1);
  // await listingService.createListing(lodging1);

  // Test updating with invalid values (should throw an error)
  // await listingService.updateListing(lodging1.getID(), price: -1);

  //THIS IS WHAT U USE FOR TESTING flutter run --target=lib/Classes/test.dart

}