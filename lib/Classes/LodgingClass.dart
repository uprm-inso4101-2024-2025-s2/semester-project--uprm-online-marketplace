import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProductClass.dart';
import 'dart:math';

/// Lodging class represents a rental listing with specific housing attributes.
class Lodging extends Product {
  final int id;
  String location;
  int bedrooms;
  int restrooms;
  int parking;
  bool isActive;
  List<String> imageUrls;

  /// Creates a new Lodging instance with default or provided values.
  Lodging({
    required String owner,
    required String availability,
    required String title,
    double price = 1000.0,
    this.location = 'UNKNOWN',
    String condition = "UNKNOWN",
    this.bedrooms = 0,
    this.restrooms = 0,
    this.parking = 0,
    String description = "",
    this.isActive = true,
    List<String>? imageUrls,
  })  : id = Random().nextInt(999999999),
        this.imageUrls = imageUrls ?? [],
        super(
        owner: owner,
        availability: availability,
        price: price,
        condition: condition,
        description: description,
        title: title,
      );

  /// Creates a Lodging instance from Firestore data.
  factory Lodging.fromFirestore(Map<String, dynamic> data) {
    return Lodging(
      owner: data['owner'] ?? "UNKNOWN",
      availability: data['availability'] ?? "UNKNOWN",
      title: data['title'] ?? "NO TITLE",
      price: (data['price'] as num?)?.toDouble() ?? 1000.0,
      location: data['location'] ?? 'UNKNOWN',
      condition: data['condition'] ?? 'UNKNOWN',
      bedrooms: data['bedrooms'] ?? 0,
      restrooms: data['restrooms'] ?? 0,
      parking: data['parking'] ?? 0,
      description: data['description'] ?? "",
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  /// Converts Lodging instance into a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'owner': owner,
      'availability': availability,
      'title': title,
      'price': price,
      'location': location,
      'condition': condition,
      'bedrooms': bedrooms,
      'restrooms': restrooms,
      'parking': parking,
      'description': description,
      'imageUrls': imageUrls,
    };
  }

  // Getters
  int getID() => id;
  String getLocation() => location;
  int getBedrooms() => bedrooms;
  int getRestrooms() => restrooms;
  int getParking() => parking;
  bool getStatus() => isActive;
  List<String> getImageUrls() => imageUrls;

  // Setters
  void setLocation(String location) => this.location = location;
  void setBedrooms(int bedrooms) => this.bedrooms = bedrooms;
  void setRestrooms(int restrooms) => this.restrooms = restrooms;
  void setParking(int parking) => this.parking = parking;
  void setStatus(bool status) => isActive = status;
  void setImageUrls(List<String> imageUrls) => this.imageUrls = imageUrls;

  // Image URL Manipulation
  void removeImageUrl(String imageUrl) => imageUrls.remove(imageUrl);
  void addImageUrl(String imageUrl) => imageUrls.add(imageUrl);
}

/// LodgingManagement class encapsulates Lodging CRUD operations with validation.
class LodgingManagement {
  final List<Lodging> lodgings = [];
  List<Lodging> getLodgings() => lodgings;

  /// Adds a lodging after validating required and numeric fields.
  void addLodging(Lodging lodging) {
    if (lodging.price < 0 || lodging.restrooms < 0 || lodging.bedrooms < 0 || lodging.parking < 0) {
      throw ArgumentError("Invalid Number");
    }
    if (lodging.title.isEmpty) {
      throw ArgumentError("Title is Required");
    }
    if (lodging.owner.isEmpty) {
      throw ArgumentError("Owner is Required");
    }
    if (lodging.availability.isEmpty) {
      throw ArgumentError("Availability Status is Required");
    }
    lodgings.add(lodging);
    print("Lodging added: \${lodging.title}");
  }

  /// Deletes lodging by ID.
  void deleteLodging(Lodging lodging, int id) {
    String tempTitle = lodging.title;
    lodgings.removeWhere((lodging) => lodging.id == id);
    print("\$tempTitle has been removed");
  }

  /// Finds a lodging with the given ID.
  Lodging? findLodgingWithId(int id) {
    return lodgings.firstWhere((lodging) => lodging.id == id);
  }

  /// Edits a lodging, updating only the fields that are provided.
  Lodging? editLodging(
      int id, {
        String? newTitle,
        String? newCondition,
        String? newDescription,
        double? newPrice,
        String? newLocation,
        int? newBedrooms,
        int? newRestrooms,
        int? newParking,
        List<String>? newImageUrls,
      }) {
    Lodging? lodging = findLodgingWithId(id);
    if (lodging != null) {
      if ((newPrice != null && newPrice < 0) ||
          (newRestrooms != null && newRestrooms < 0) ||
          (newBedrooms != null && newBedrooms < 0) ||
          (newParking != null && newParking < 0)) {
        throw ArgumentError("Invalid Number");
      }
      if (newTitle != null && newTitle.isEmpty) {
        throw ArgumentError("Title is Required");
      }
      if (newTitle != null) lodging.title = newTitle;
      if (newCondition != null) lodging.condition = newCondition;
      if (newDescription != null) lodging.description = newDescription;
      if (newPrice != null) lodging.price = newPrice;
      if (newLocation != null) lodging.location = newLocation;
      if (newBedrooms != null) lodging.bedrooms = newBedrooms;
      if (newRestrooms != null) lodging.restrooms = newRestrooms;
      if (newParking != null) lodging.parking = newParking;
      if (newImageUrls != null) lodging.imageUrls = newImageUrls;

      print("Lodging with ID \$id has been updated");
      return lodging;
    } else {
      print("ID \$id was not found");
    }
  }

  /// Removes all lodgings. Note: This is O(n) and should be used with caution.
  void clearLodgings() {
    lodgings.clear();
  }
}

/// Firestore serialization extension for Lodging.
extension LodgingFirestore on Lodging {
  static Lodging fromFirestore(Map<String, dynamic> data) {
    return Lodging(
      owner: data['owner'] ?? "UNKNOWN",
      availability: data['availability'] ?? "UNKNOWN",
      title: data['title'] ?? "NO TITLE",
      price: data['price'] ?? 1000,
      location: data['location'] ?? 'UNKNOWN',
      condition: data['condition'] ?? 'UNKNOWN',
      bedrooms: data['bedrooms'] ?? 0,
      restrooms: data['restrooms'] ?? 0,
      parking: data['parking'] ?? 0,
      description: data['description'] ?? "",
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'owner': owner,
      'availability': availability,
      'title': title,
      'price': price,
      'location': location,
      'condition': condition,
      'bedrooms': bedrooms,
      'restrooms': restrooms,
      'parking': parking,
      'description': description,
      'imageUrls': imageUrls,
    };
  }
}
