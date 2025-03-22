import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Displays a Google Map that allows users to search for locations,
/// add markers, and manage marker interactions.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  /// The default camera position centered at UPRM.
  static const CameraPosition _UPRM = CameraPosition(
    target: LatLng(18.2106, -67.1418),
    zoom: 15,
  );

  /// Assigns the created map controller to enable map interactions.
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// A spacer widget for consistent layout spacing.
  Widget space = const SizedBox(height: 10);

  /// A search bar widget for inputting locations in "lat, lng" format.
  late final Widget searchBar = SearchBar(
    hintText: " Search a location: latitude, longitude",
    onSubmitted: _submitSearch,
  );

  /// A button that adds a marker at the center of the current map view.
  late final Widget addMarkerButton = FloatingActionButton(
    onPressed: _addMarker,
    child: const Icon(Icons.add_location),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listings Map Page')),
      body: Center(
        child: Column(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            searchBar,
            // Expanded widget prevents layout overflow when displaying the map.
            Expanded(
              // The dynamic map widget allows marker updates during runtime.
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
      // A secondary action that navigates the camera to the default location.
      floatingActionButton: FloatingActionButton(
        onPressed: _goToUPRM,
        child: const Icon(Icons.school),
      ),
    );
  }

  /// Converts the input string into coordinates and navigates the map.
  ///
  /// If the input is valid, it moves the camera to the specified location;
  /// otherwise, it shows an error message.
  void _submitSearch(String input) {
    List<String> coords = input.split(",");
    if (coords.length == 2) {
      try {
        final latitude = double.parse(coords[0].trim());
        final longitude = double.parse(coords[1].trim());
        _goToSearch(LatLng(latitude, longitude));
      } catch (e) {
        _showError("Invalid coordinates: $input.");
      }
    } else {
      _showError("Invalid input format. Expected: lat, lng");
    }
  }

  /// Animates the map camera to focus on the provided coordinates.
  ///
  /// Uses a predefined zoom level to ensure clarity.
  Future<void> _goToSearch(LatLng coords) async {
    if (mapController == null) return;
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: coords, zoom: 16),
      ),
    );
  }

  /// Navigates the map camera to the default UPRM location.
  Future<void> _goToUPRM() async {
    _goToSearch(_UPRM.target);
  }

  /// Determines the center of the visible map area and places a marker.
  Future<void> _addMarker() async {
    if (mapController == null) return;
    LatLngBounds region = await mapController.getVisibleRegion();
    LatLng coords = LatLng(
      (region.northeast.latitude + region.southwest.latitude) / 2,
      (region.northeast.longitude + region.southwest.longitude) / 2,
    );
    _placeMarker(coords);
  }

  /// Adds a marker at the given location with an info window that supports deletion.
  ///
  /// The info window displays the coordinates, and tapping it removes the marker.
  void _placeMarker(LatLng coords) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(coords.toString()),
        position: coords,
        infoWindow: InfoWindow(
          title: "Tap to Delete",
          snippet: "Latitude: ${coords.latitude}, Longitude: ${coords.longitude}",
          onTap: () => _deleteMarker(coords.toString()),
        ),
      ));
    });
  }

  /// Removes a marker based on its unique identifier.
  void _deleteMarker(String id) {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == id);
    });
  }

  /// Displays an error message to the user via a Snackbar.
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
