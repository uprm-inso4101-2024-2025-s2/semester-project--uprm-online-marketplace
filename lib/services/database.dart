// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../Classes/LodgingClass.dart';
//USELESS CURRENTLY
// const String LISTINGS_COLLECTION_REF = "listings";
//
// class DatabaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   late final CollectionReference<Lodging> _listingsRef;
//
//   DatabaseService() {
//     _listingsRef = _firestore.collection(LISTINGS_COLLECTION_REF).withConverter<Lodging>(
//       fromFirestore: (snapshot, _) => LodgingFirestore.fromFirestore(snapshot.data()!),
//       toFirestore: (lodging, _) => lodging.toFirestore(),
//     );
//   }
// }
// USELESS CURRENTLY
