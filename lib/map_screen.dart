import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';


class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final loc.Location location =loc.Location();

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  List <QueryDocumentSnapshot>data=[];
  LocationData? currentLocation;

  getData()async{
    QuerySnapshot querySnapshot =await FirebaseFirestore.instance.collection('users').get();
    data.addAll(querySnapshot.docs);
    setState(() {
    });

  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return GoogleMap(
              initialCameraPosition:
              CameraPosition(target: LatLng(
                  snapshot.data!.docs[0].data()['lat'],
                  snapshot.data!.docs[0].data()['long']
              ), zoom: 14.5),
              markers: {
                Marker(
                  markerId: const MarkerId('current'),
                  position: LatLng(
                      snapshot.data!.docs[0].data()['lat'],
                      snapshot.data!.docs[0].data()['long']),
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            );
          }
          return const Text('loading');
        },
      ),
    );
  }

}
