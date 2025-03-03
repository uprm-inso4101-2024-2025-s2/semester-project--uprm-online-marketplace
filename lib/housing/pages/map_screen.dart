import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A widget containing a Google Map with functionality
/// to search locations and add markers.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  /// Default camera position on a zoomed out view of
  /// the University of Puerto Rico at Mayagüez.
  static const CameraPosition _UPRM = CameraPosition(
    target: LatLng(18.2106, -67.1418),
    zoom: 15,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Basic UI Elements
  Widget space = const SizedBox(height: 10);

  late final Widget searchBar = SearchBar(
    hintText: " Search a location: latitude, longitude",
    onSubmitted: _submitSearch,
  );

  late final Widget addMarkerButton = FloatingActionButton(
      onPressed: _addMarker,
      child : const Icon(Icons.add_location)
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Listings Map Page')),
      body: Center(
        child: Column(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            searchBar,
            // The Expanded Widget is necessary to avoid pixel overflow by map
            Expanded (
              // The map must be declared dynamically,
              // refactoring to a variable would not let markers update
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _UPRM,
                markers: _markers,
              ),
            ),
            addMarkerButton,
            space,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToUPRM,
        child: const Icon(Icons.school),
      ),
    );
  }


  /// Parses a user input string into latitude and longitude coordinates.
  ///
  /// If the input is valid, it calls [_goToSearch] to move the map to the specified location.
  /// If the input is invalid, an error message is shown to the user.
  ///
  /// [input] A string containing the latitude and longitude in the format "lat, lng".
  void _submitSearch(String input){
    List<String> coords = input.split(",");
    if(coords.length == 2){
      try{
        final latitude = double.parse(coords[0].trim());
        final longitude = double.parse(coords[1].trim());
        _goToSearch(LatLng(latitude, longitude));
      } catch (e) {
        _showError("Invalid coordinates: $input.");
      }
    }
    else {
      _showError("Invalid input format. Expected: lat, lng");
    }
  }

  /// Moves the map focus to the specified coordinates.
  ///
  /// This function animates the camera to zoom into a specific location on the map.
  /// If the [mapController] is not initialized, it does nothing.
  ///
  /// [coords] The latitude and longitude of the location to navigate to.
  ///
  /// Returns a [Future] that completes when the camera animation is done.
  Future<void> _goToSearch(LatLng coords) async {
    if(mapController == null) return;
    await mapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: coords, zoom: 16))
    );
  }

  /// Moves the map focus to the default UPRM location.
  Future<void> _goToUPRM() async {
    _goToSearch(_UPRM.target);
  }

  /// Retrieves the center coordinates of the visible map and places a marker.
  Future<void> _addMarker() async {
    if(mapController == null) return;
    LatLngBounds region =  await mapController.getVisibleRegion();
    LatLng coords = LatLng(
      (region.northeast.latitude + region.southwest.latitude) / 2,
      (region.northeast.longitude + region.southwest.longitude) / 2,
    );
    _placeMarker(coords);
  }

  /// Places a marker at the specified coordinates on the map.
  ///
  /// The marker displays the latitude and longitude in an info window.
  /// Tapping the info window deletes the marker.
  ///
  /// [coords] The [LatLng] position where the marker should be placed.
  void _placeMarker(LatLng coords){
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(coords.toString()),
        position: coords,
        infoWindow: InfoWindow(
            title: "Tap to Delete",
            snippet: "Latitude: ${coords.latitude}, Longitude: ${coords.longitude}",
            // Tap the text of the info window to delete the marker.
            onTap: () => _deleteMarker(coords.toString())
        ),
      ));
    });
  }

  /// Deletes a marker given it unique ID.
  ///
  /// This is for later when a landlord wants to delete the marker of listing
  /// or if the listing itself is deleted.
  ///
  /// [id] The [markerID.value] of the marker to be removed from the map.
  void _deleteMarker(String id){
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == id);
    });
  }

  /// Shows an error message in a Snackbar.
  ///
  /// [message] The error message to be shown to the user.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}