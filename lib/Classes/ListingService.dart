import 'LodgingClass.dart';

class ListingService extends LodgingManagement{
//Identify the Listings as Maps to easily access the value based off
//the key (ID), value will be the lodging. This ensures duplicates are not
//created.

//Since LodgingManagement already has error handling implemented for these methods,
//this class will handle duplicates utilizing IDs.

//For now the listings will be utilizing the Lodging class, if the project were
//to expand and utilize other products, this value type might change.
  final Map<int, Lodging> listings= {};

  @override
  void createListing(Lodging lodging){
    if(listings.containsKey(lodging.getID())){
      throw ArgumentError('No Duplicates Allowed.');
    }else{
      listings[lodging.getID()]= lodging;
      super.addLodging(lodging);
    }
  }

  @override
  List<Lodging> fetchListings() {
    return super.getLodgings().where((lodging) => lodging.isActive).toList();
  }

  // Fetch all listings (active and inactive) by owner
  List<Lodging> fetchOwnerListings(String owner) {
    return super.getLodgings().where((lodging) => lodging.getOwner() == owner).toList();
  }

  Lodging? fetchLodging(int ID){
    if(listings.containsKey(ID)){
      if(findLodgingWithId(ID)!=null){
        return listings[ID];
      }else{
        throw ArgumentError("Item not Found.");
      }
    }else{
      throw ArgumentError("Item not Found.");
    }
  }

  @override
  void updateListing(int id, {String? title, String? condition, String? description, int? price, String? location, int? bedrooms, int? restrooms, int? parking}){
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
          newParking:parking
      );
      if(newLodging!=null){
        listings[id]= newLodging;
      }
    }
  }

  @override
  void deleteListing(int id){
    if(listings.containsKey(id)) {
      Lodging? lodging = findLodgingWithId(id);
      if(lodging!=null){
        deleteLodging(lodging, id);
        listings.remove(id);
      }else{
        throw ArgumentError("Item does not exist.");
      }

    }else{
      throw ArgumentError("Item does not exist.");
    }
  }

  @override
  void clearListing(){
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