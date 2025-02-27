import 'ProductClass.dart';
import 'dart:math';


class Lodging extends Product{
  final int id; 
  String location;
  int bedrooms;
  int restrooms;
  int parking;

  Lodging({
    required String owner,
    required String availability,
    required String title,
    int price = 1000,
    this.location = 'UNKNOWN',
    String condition = "UNKNOWN",
    this.bedrooms = 0,
    this.restrooms = 0,
    this.parking = 0,
    String description = ""
  }): id = Random().nextInt(999999999), //we will  locate listings using a random numberID. This will make us be able to locate listings more efficiently rather than by title. Titles could be the same
    super(owner:owner, availability:availability, price:price, condition:condition, description:description, title:title);

  //Getters
  int getID() => id;
  String getLocation() => location;
  int getBedrooms() => bedrooms;
  int getRestrooms() => restrooms;
  int getParking() => parking;

  //Setters
  void setLocation(String location) => this.location = location;
  void setBedrooms(int bedrooms) => this.bedrooms = bedrooms;
  void setRestrooms(int restrooms) => this.restrooms = restrooms;
  void setParking(int parking) => this.parking = parking;

}

class LodgingManagement{
  final List<Lodging> lodgings = [];
  List<Lodging> getLodgings() => lodgings;

  void addLodging(Lodging lodging){ //these ifs make it so that u CANT input an incorrect value
    if(lodging.price < 0 || lodging.restrooms < 0 || lodging.bedrooms < 0 || lodging.parking < 0){
      throw ArgumentError("Invalid Number");
    }
    if(lodging.title.isEmpty){
      throw ArgumentError("Title is Required");
    }
    if(lodging.owner.isEmpty){
      throw ArgumentError("Owner is Required");
    }
    if(lodging.availability.isEmpty){
      throw ArgumentError("Availability Status is Required");
    }
    lodgings.add(lodging);
    print("Lodging added: ${lodging.title}");
  }

  void deleteLodging(Lodging lodging, int id){ 
  // The user can only select an existing ID from the frontend, 
  // so there's no need to check if the ID exists before deleting.
    String tempTitle = lodging.title;
    lodgings.removeWhere((lodging) => lodging.id == id);
    print("$tempTitle has been removed");
  }

  Lodging? findLodgingWithId(int id){ //returns the lodging with the corresponding unique ID 
    return lodgings.firstWhere((lodging) => lodging.id == id);
  }

  //the question marks allow each parameter to be optional
  void editLodging(int id, {String? newTitle, String? newCondition, String? newDescription,int? newPrice, String? newLocation, int? newBedrooms, int? newRestrooms, int? newParking}){
    Lodging? lodging = findLodgingWithId(id);
    
    if(lodging != null){
      if(newPrice != null && newPrice < 0 || newRestrooms != null && newRestrooms < 0 || newBedrooms != null && newBedrooms < 0 || newParking != null && newParking < 0){
        throw ArgumentError("Invalid Number");
      }
      if(newTitle != null && newTitle.isEmpty){
        throw ArgumentError("Title is Required");
      }

      if(newTitle != null) lodging.title = newTitle;
      if(newCondition != null) lodging.condition = newCondition;
      if(newDescription != null) lodging.description = newDescription;
      if(newPrice != null && newPrice >= 0) lodging.price = newPrice;
      if(newLocation != null) lodging.location = newLocation;
      if(newBedrooms != null && newBedrooms >= 0) lodging.bedrooms = newBedrooms;
      if(newRestrooms != null && newRestrooms >= 0) lodging.restrooms = newRestrooms;
      if(newParking != null && newParking >= 0) lodging.parking = newParking;

      print("Lodging with ID $id has been updated");
    }
    else{
      print("ID $id was not found");
    }
  }


}
