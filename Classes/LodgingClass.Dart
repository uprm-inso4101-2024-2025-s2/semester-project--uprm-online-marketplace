import 'ProductClass.dart';

class Lodging extends Product{
  String location;
  int bedrooms;
  int restrooms;
  int parking;

  Lodging(
    {required String owner,
    required String availability,
    int price = 1000,
    this.location = 'UNKNOWN',
    String condition = "UNKNOWN",
    this.bedrooms = 0,
    this.restrooms = 0,
    this.parking = 0,
    String description = ""})
    :super(owner:owner, availability:availability, price:price, condition:condition, description:description);

  //Getters
  String getLocation() => location;
  int getBedrooms() => bedrooms;
  int getRestrooms() => restrooms;
  int getParking() => parking;

  //Setters
  void setLocation(String location) => this.location = location;
  void setBedrooms(int bedrooms) => this.bedrooms = bedrooms;
  void setRestrooms(int restrooms) => this.restrooms = restrooms;
  void setParking(int oarking) => this.parking = parking;

}
