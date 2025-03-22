import 'LodgingClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingService extends LodgingManagement {
  /// Internal in-memory storage to prevent duplicate listings.
  final Map<int, Lodging> listings = {};

  /// Singleton instance setup for ListingService.
  static final ListingService _instance = ListingService._internal();
  ListingService._internal();
  factory ListingService() => _instance;

  /// Create a new listing and persist it to Firestore.
  @override
  Future<void> createListing(Lodging lodging) async {
    if (listings.containsKey(lodging.getID())) {
      throw ArgumentError('No Duplicates Allowed.');
    }

    listings[lodging.getID()] = lodging;
    super.addLodging(lodging);

    await FirebaseFirestore.instance
        .collection("listings")
        .doc(lodging.getID().toString())
        .set(lodging.toFirestore());
  }

  /// Fetch all listings from Firestore.
  @override
  Future<List<Lodging>> fetchListings() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('listings').get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Lodging.fromFirestore(data);
    }).toList();
  }

  /// Fetch a single listing by ID.
  Future<Lodging?> fetchListing(int id) async {
    DocumentSnapshot doc =
    await FirebaseFirestore.instance.collection('listings').doc(id.toString()).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Lodging.fromFirestore(data);
    }
    return null;
  }

  /// Fetch all listings (active or inactive) from a specific owner.
  List<Lodging> fetchOwnerListings(String owner) {
    return super.getLodgings().where((l) => l.getOwner() == owner).toList();
  }

  /// Update a listing both locally and in Firestore.
  @override
  Future<void> updateListing(
      int id, {
        String? title,
        String? condition,
        String? description,
        double? price,
        String? location,
        int? bedrooms,
        int? restrooms,
        int? parking,
        bool? isActive,
        List<String>? imageUrls,
      }) async {
    if (!listings.containsKey(id)) {
      throw ArgumentError("Item not Found.");
    }

    Lodging? updated = editLodging(
      id,
      newTitle: title,
      newCondition: condition,
      newDescription: description,
      newPrice: price,
      newLocation: location,
      newBedrooms: bedrooms,
      newRestrooms: restrooms,
      newParking: parking,
      newImageUrls: imageUrls,
    );

    if (updated != null) {
      listings[id] = updated;

      await FirebaseFirestore.instance.collection('listings').doc(id.toString()).update({
        if (title != null) 'title': title,
        if (condition != null) 'condition': condition,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        if (location != null) 'location': location,
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (restrooms != null) 'restrooms': restrooms,
        if (parking != null) 'parking': parking,
        if (imageUrls != null) 'imageUrls': imageUrls,
      });
    }
  }

  /// Delete a listing both locally and in Firestore.
  @override
  Future<void> deleteListing(int id) async {
    if (!listings.containsKey(id)) {
      throw ArgumentError("Item does not exist.");
    }

    Lodging? lodging = findLodgingWithId(id);
    if (lodging != null) {
      deleteLodging(lodging, id);
      listings.remove(id);
      await FirebaseFirestore.instance.collection('listings').doc(id.toString()).delete();
    } else {
      throw ArgumentError("Item does not exist.");
    }
  }

  /// Clear all listings from both memory and Firestore.
  @override
  Future<void> clearListing() async {
    var collection = FirebaseFirestore.instance.collection('listings');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    listings.clear();
    clearLodgings();
  }

  /// Toggle a listing's active status.
  void toggleListingStatus(int id, bool isActive) {
    if (!listings.containsKey(id)) {
      throw ArgumentError("Listing not found.");
    }
    listings[id]?.setStatus(isActive);
  }
}