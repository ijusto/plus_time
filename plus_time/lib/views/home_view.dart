/* Based on a tutorial: https://www.youtube.com/watch?v=UdBUe_NP-BI */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plus_time/datamodels/user_location.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
        body: Center(
      child: Text(
          "Location: Lat: ${userLocation.latitude}, Long: ${userLocation.longitude}"),
    ));
  }
}
