import 'LodgingClass.dart';

void main(){
  LodgingManagement lodgingManager = LodgingManagement();
  Lodging testLodging = Lodging(
    owner: "Michael",
    availability: "true",
    price: 1200,
    location: "Downtown",
    condition: "Good",
    bedrooms: 3,
    restrooms: 2,
    parking: 1,
    description: "Spacious apartment",
    title: "Apartment"
  );

  // print(testLodging is Product); //Should print true

  print(testLodging.getOwner()); //Michael
  print(testLodging.getAvailability()); //true
  print(testLodging.getPrice()); //1200
  print(testLodging.getLocation()); //Downtown
  print(testLodging.getCondition()); //Good
  print(testLodging.getBedrooms()); //3
  print(testLodging.getRestrooms()); //2
  print(testLodging.getParking()); //1
  print(testLodging.getDescription()); //Spacious apartment
  print(testLodging.getTitle()); //Apartment
  print(testLodging.getID()); //Random Numbers

  // Add and find lodging
  lodgingManager.addLodging(testLodging);
  print(lodgingManager.findLodgingWithId(testLodging.getID()) != null ? "Add & Find Test Passed" : "Add & Find Test Failed");

  // Prevent invalid lodging (negative price)
  try {
    lodgingManager.addLodging(Lodging(owner: "John", availability: "true", price: -500, title: "Bad"));
    print("Invalid Price Test Failed");
  } catch (e) {
    print("Invalid Price Test Passed");
  }
  
  // Edit and delete lodging
  int id = testLodging.getID();
  lodgingManager.editLodging(id, newPrice: 1500);
  print(lodgingManager.findLodgingWithId(id)?.price == 1500 ? "Edit Test Passed" : "Edit Test Failed");

  lodgingManager.deleteLodging(testLodging, id);
  print(lodgingManager.findLodgingWithId(id) == null ? "Delete Test Passed" : "Delete Test Failed"); //look at deleteLodging function in LodgingClass.dart
}
