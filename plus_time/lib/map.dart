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
  MapPage({Key key, this.locations, this.recentLoc, this.locationService})
      : super(key: key);
  final List<Location> locations;
  final Location recentLoc;
  final LocationService locationService;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController _mapController;
  //LocationService locServ;
  AccessesGivenDao permAccess;
  bool _isLoading = true;
  UserLocation userLocation;
  void _onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _onLoading();
  }

  Future getUserLocation() async {
    permAccess = Provider.of<AppDatabase>(context).accessesGivenDao;
    permAccess.getAllAccessesGivens().then((perms) async {
      for (AccessGivenEntry perm in perms) {
        if (perm.typeOfAccess == "location" && !perm.granted) {
          widget.locationService.requestPerm();
          bool calperm = widget.locationService.isPermGranted;
          AccessGivenEntry calAccess =
              new AccessGivenEntry(typeOfAccess: "location", granted: calperm);
          await widget.locationService.getUserLocation();
        }
      }
    });
    //widget.locationService.getLocation();
    userLocation = Provider.of<UserLocation>(context);
    print("User loc: " + userLocation.latitude.toString());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      getUserLocation();
    }
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
        body: Stack(children: <Widget>[
          if (_isLoading) ...[
            Center(
              child: CircularProgressIndicator(),
            )
          ] else ...[
            new FlutterMap(
              mapController: _mapController,
              options: new MapOptions(
                center:
                    new LatLng(userLocation.latitude, userLocation.longitude),
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
                        LatLng(widget.recentLoc.latitude,
                            widget.recentLoc.longitude)
                      ],
                      color: Colors.yellow,
                      strokeWidth: 4.1,
                    )
                  ]),
                ],
                new MarkerLayerOptions(
                  markers: [
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      point: new LatLng(
                          userLocation.latitude, userLocation.longitude),
                      builder: (ctx) => new Container(
                          child: Icon(Icons.location_on, color: Colors.blue)),
                    ),
                    for (Location loc in widget.locations) ...[
                      new Marker(
                        width: 80.0,
                        height: 80.0,
                        point: new LatLng(loc.latitude, loc.longitude),
                        builder: (ctx) => new Container(
                            child:
                                Icon(Icons.location_on, color: Colors.green)),
                      ),
                    ],
                  ],
                ),
              ],
            )
          ]
        ]));
  }
}
