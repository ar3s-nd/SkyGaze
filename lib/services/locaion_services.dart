import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<String?> getCityName() async {
  LocationPermission permission;
  bool activeConnection = false;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      activeConnection = true;
    }
  } on SocketException catch (_) {
    activeConnection = false;
  }

  if (!activeConnection) {
    // Show a pop-up to turn on mobile data
    return Future.error('No internet connection.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, return null or handle the error
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, return null or handle the error
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can get the current location
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      return placemarks.first.locality;
    } else {
      return null;
    }
  } catch (e) {
    return Future.error('Error occurred: $e');
  }
}

