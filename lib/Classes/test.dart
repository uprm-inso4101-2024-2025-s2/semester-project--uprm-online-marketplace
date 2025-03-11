import 'LodgingClass.dart';
import 'ListingService.dart';

//LodgingClass Tester (uncomment to use)
//////////////////////////////////////////////////////////////////
// void main(){
//   LodgingManagement lodgingManager = LodgingManagement();
//   Lodging testLodging = Lodging(
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

// ListingService Tester (uncomment to use)

import 'LodgingClass.dart';
import 'ListingService.dart';

void main(){
  ListingService listingService;
  Lodging lodging1;
  Lodging lodging2;

  listingService = ListingService();
  lodging1 = Lodging(
    owner: 'Owner1',
    availability: 'Available',
    title: 'Lodging 1',
    price: 1000,
    location: 'Location 1',
    condition: 'Good',
    bedrooms: 2,
    restrooms: 1,
    parking: 1,
    isActive: true, // NEW parameter added
  );

  lodging2 = Lodging(
    owner: "Owner2",
    availability: 'Not Available',
    title: 'Lodging 2',
    price: 1500,
    location: 'Location2',
    condition: 'Excellent',
    bedrooms: 3,
    restrooms: 2,
    parking: 2,
    isActive: true, // NEW parameter added
  );

  // Test should create a listing successfully.
  listingService.createListing(lodging1);
  print(listingService.fetchListings().length); //expects 1
  print(listingService.fetchListings().first.title); //expects 'Lodging 1'

  listingService.clearListing();

  //Test should fetch listings correctly.
  listingService.createListing(lodging1);
  listingService.createListing(lodging2);
  List<Lodging> listings = listingService.fetchListings();
  print(listings.length); //expects 2
  print(listings[0].title); //expects 'Lodging 1'
  print(listings[1].title); //expects 'Lodging 2'
  listingService.clearListing();

  //Test should update an existing listing correctly.
  listingService.createListing(lodging1);
  listingService.updateListing(lodging1.getID(), title:'Updated Lodging 1', price: 1200);
  Lodging updatedLodging= listingService.fetchListings().firstWhere((lodging) => lodging.getID()==lodging1.getID());
  print(updatedLodging.title); //expects 'Updated Lodging 1'
  print(updatedLodging.price); // expects 1200
  listingService.clearListing();

  //Test should delete a listing correctly.
  listingService.createListing(lodging1);
  listingService.createListing(lodging2);
  listingService.deleteListing(lodging1.getID());
  print(listingService.fetchListings().length); //expects 1
  print(listingService.fetchListings().first.title); //expects 'Lodging 2'
  listingService.clearListing();

  //Test should return the correct lodging when given ID exists.
  listingService.createListing(lodging1);
  final fetchedLodging = listingService.fetchLodging(lodging1.getID());
  print(fetchedLodging); //Is not null
  print(fetchedLodging?.title); //expects 'Lodging 1'
  print(fetchedLodging?.price); //expects 1000
  print(fetchedLodging?.location); //expects 'Location 1'

  //**Comment after use or the rest of the test will not work.
  //Test should throw ArgumentError when the given ID does not exist.
  //listingService.fetchLodging(99999999);
  listingService.clearListing();

  //**Comment this after use or the rest of the tests will not work.**
  //Test should throw an error for trying to add duplicates
  //listingService.createListing(lodging1);
  //listingService.createListing(lodging1);
  //listingService.clearListing();

  //**Comment this after use or the rest of the tests will not work. **
  //Test should throw an error for updating with invalid values
  //listingService.createListing(lodging1);
  //listingService.updateListing(lodging1.getID(), price: -1);

  // NEW TEST CASES ADDED BELOW 👇
  print("\n---- New Active/Inactive Listings Tests ----");

  // Initially active listing should appear
  listingService.createListing(lodging1);
  print("Initially active listings count: ${listingService.fetchListings().length}"); // Expects: 1

  // Test: Mark listing as inactive
  listingService.toggleListingStatus(lodging1.getID(), false);
  print("Listings after deactivation: ${listingService.fetchListings().length}"); // Expects: 0 (hidden)

  // Owner should still see inactive listings
  List<Lodging> ownerListings = listingService.fetchOwnerListings("Owner1");
  print("Owner listings (including inactive): ${ownerListings.length}"); // Expects: 1

  // Reactivate listing and verify visibility
  listingService.toggleListingStatus(lodging1.getID(), true);
  print("Listings after reactivation: ${listingService.fetchListings().length}"); // Expects: 1 (visible again)

  listingService.clearListing();
}