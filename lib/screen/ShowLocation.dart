import 'dart:io';

import 'package:carwash/constants.dart';
import 'package:carwash/model/User.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';


// https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6


class ShowLocation extends StatefulWidget {
  final User? user;
  const ShowLocation(this.user);

  @override
  State<ShowLocation> createState() => _ShowLocationState();
}

const kGoogleApiKey = 'AIzaSyBgOM4iXth5olyb34-rcv9lbZsMcINhIvw';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _ShowLocationState extends State<ShowLocation> {

  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;
  FocusNode focusNode = FocusNode();

  String? _currentAddress;
  final myController = TextEditingController();

  double lng = 0.0;
  double lat = 0.0;

  static CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.42796, -122.08574), zoom: 14.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    });

    if(widget.user?.long!=null){
      double lat=double.parse('${widget.user?.lat}');
      double long=double.parse('${widget.user?.long}');
      initialCameraPosition = CameraPosition(target: LatLng( lat,long), zoom: 14.0);
      setState(() {
        markersList.add(
            Marker(
                markerId: const MarkerId("0"),
                position: LatLng(lat, long),
                infoWindow: InfoWindow(title: widget.user?.address)
            )
        );
      });
    }
    _currentAddress=widget.user?.address;
  }

  @override
  void dispose() {
    myController.dispose();
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: Const.appbar('Update Google Location'),
      body: Container(
          color: Const.primaryColor,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GoogleMap(
                        initialCameraPosition: initialCameraPosition,
                        markers: markersList,
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          googleMapController = controller;
                        },
                        circles: Set.from([
                          Circle(
                            circleId: CircleId("1"),
                            center: LatLng(lat, lng),
                            radius: 1000, // 1000 meters
                            fillColor: Colors.blue.withOpacity(0.3),
                            strokeColor: Colors.blue,
                            strokeWidth: 2,
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        logo: SizedBox(),
        decoration: InputDecoration(
            hintText: 'Search your home location',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))
        ),
        components: [
          Component(Component.country, "pk"),
          Component(Component.country, "usa"),
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      Const.toastMessage(response.errorMessage!)
    );
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {

    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey, apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    lat = detail.result.geometry!.location.lat;
    lng = detail.result.geometry!.location.lng;
    markersList.add(
        Marker(
            markerId: const MarkerId("0"),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: detail.result.name)
        )
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    setState(() {
      print(p.description);
      print('p.description');
      _currentAddress= p.description;

    });
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 13.0));
  }
  Widget fakeInput(String title){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.shade500
          ),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Text(title,style: TextStyle(fontSize: 17),),
    );
  }

}
