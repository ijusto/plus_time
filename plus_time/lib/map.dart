import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:plus_time/data/moor_database.dart';
import 'package:plus_time/datamodels/user_location.dart';
import 'package:plus_time/services/locationService.dart';
import 'package:provider/provider.dart';

class Location {
  final double latitude;
  final double longitude;

  Location({this.latitude, this.longitude});
}

class MapPage extends StatefulWidget {
  MapPage({Key key, this.locations, this.recentLoc}) : super(key: key);
  final List<Location> locations;
  final Location recentLoc;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController _mapController;
  LocationService locServ;
  AccessesGivenDao permAccess;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    permAccess = Provider.of<AppDatabase>(context).accessesGivenDao;
    locServ = Provider.of<LocationService>(context);
    permAccess.getAllAccessesGivens().then((perms) {
      for (AccessGivenEntry perm in perms) {
        if (perm.typeOfAccess == "location" && !perm.granted) {
          locServ.requestPerm();
        }
      }
    });
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
        floatingActionButton: Row(children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.zoom_in),
            onPressed: () {
              var newZoom = _mapController.zoom + 1;
              _mapController.move(_mapController.center, newZoom);
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.zoom_out),
            onPressed: () {
              var newZoom = _mapController.zoom - 1;
              _mapController.move(_mapController.center, newZoom);
            },
          ),
        ]),
        body: new FlutterMap(
          mapController: _mapController,
          options: new MapOptions(
            center: new LatLng(userLocation.latitude, userLocation.longitude),
            zoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            if (widget.recentLoc != null) ...[
              new PolylineLayerOptions(polylines: [
                Polyline(
                  points: <LatLng>[
                    LatLng(userLocation.latitude, userLocation.longitude),
                    LatLng(
                        widget.recentLoc.latitude, widget.recentLoc.longitude)
                  ],
                  color: Colors.black,
                  strokeWidth: 4.1,
                )
              ]),
            ],
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point:
                      new LatLng(userLocation.latitude, userLocation.longitude),
                  builder: (ctx) =>
                      new Container(child: Icon(Icons.location_on)),
                ),
                for (Location loc in widget.locations) ...[
                  new Marker(
                    width: 80.0,
                    height: 80.0,
                    point: new LatLng(loc.latitude, loc.longitude),
                    builder: (ctx) =>
                        new Container(child: Icon(Icons.location_on)),
                  ),
                ],
              ],
            ),
          ],
        ));
  }
}
