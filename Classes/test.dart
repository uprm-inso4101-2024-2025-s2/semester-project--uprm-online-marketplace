import 'LodgingClass.dart';
import 'ProductClass.dart';

void main(){
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
  );

  print(testLodging is Product); //Should print true

  print(testLodging.getOwner()); //Michael
  print(testLodging.getAvailability()); //true
  print(testLodging.getPrice()); //1200
  print(testLodging.getLocation()); //Downtown
  print(testLodging.getCondition()); //Good
  print(testLodging.getBedrooms()); //3
  print(testLodging.getRestrooms()); //2
  print(testLodging.getParking()); //1
  print(testLodging.getDescription()); //Spacious apartment
}
