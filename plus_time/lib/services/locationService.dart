import 'dart:async';

import 'package:location/location.dart';
import 'package:plus_time/datamodels/user_location.dart';

/* Based on a tutorial: https://www.youtube.com/watch?v=UdBUe_NP-BI */

class LocationService {
  // keep track of the current location
  UserLocation _currentLocation;
  Location location = Location();
  bool perm;

  bool get isPermGranted => perm;

  // Continuously emit location updates
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  LocationService() {
    perm = false;
  }

  Future requestPerm() async {
    if (!perm) {
      PermissionStatus granted = await location.requestPermission();
      if (granted == PermissionStatus.GRANTED) {
        perm = true;
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
          }
        });
      }
    }
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  StreamController<UserLocation> get locationController => _locationController;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
          latitude: userLocation.latitude, longitude: userLocation.longitude);
    } catch (e) {
      print("Could not get the location: $e");
    }

    return _currentLocation;
  }
}
