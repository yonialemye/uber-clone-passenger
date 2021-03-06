import 'dart:async' show Completer;
import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_passenger/app/models/address_model.dart';
import 'package:uber_clone_passenger/app/models/passenger.dart';
import 'package:uber_clone_passenger/app/models/ride_details_model.dart';

import '../../exports/widgets.dart';
import '../../exports/services.dart';
import '../../exports/helpers.dart';
import '../../exports/constants.dart';
import '../../providers/address_provider.dart';
import '../../services/home_page_services.dart';
import 'widgets/my_drawer.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _googleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  Passenger? currentUserInfo;

  double bottomPadding = 0;
  bool? isDarkMode;
  Position? _currentPosition;

  Set<Circle> circles = {};
  Set<Marker> markers = {};

  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polyLines = {};

  @override
  void initState() {
    FirebaseServices.getCurrentUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> setPickUpAddress() async {
    _currentPosition = await Geolocator.getCurrentPosition();
    LatLng pos = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    _googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 15),
      ),
    );
    final Address address = await HomePageServices.findCoordinateAddress(
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      context: context,
      mounted: mounted,
    );
    if (mounted) Provider.of<AddressProvider>(context, listen: false).setPickUpAddress(address);
  }

  Future<void> setDestinationAddress(LatLng position) async {
    polyLineCoordinates.clear();
    polyLines.clear();
    markers.clear();
    showLoadingDialog(context: context, barrierColor: Colors.black12, text: 'Loading...');
    LatLng pos = LatLng(position.latitude, position.longitude);
    _googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 15),
      ),
    );
    final Address address = await HomePageServices.findCoordinateAddress(
      latitude: position.latitude,
      longitude: position.longitude,
      context: context,
      mounted: mounted,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    Provider.of<AddressProvider>(context, listen: false).setDestinationAddress(address);
    searchController.text = address.placeName;
    Circle destCircle = Circle(
      circleId: const CircleId('destId'),
      center: position,
      radius: 20,
      strokeColor: Colors.red,
      fillColor: Colors.red,
      strokeWidth: 3,
    );
    setState(() => circles.add(destCircle));
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    showLoadingDialog(context: context, text: 'Loading...');
    _controller.complete(controller);
    _googleMapController = controller;
    bottomPadding = 360.h;
    if (Theme.of(context).brightness == Brightness.dark) {
      _googleMapController!.setMapStyle(Values.googleMapStyleDark);
    } else {
      _googleMapController!.setMapStyle(Values.googleMapStyleLight);
    }
    final result = await HomePageServices.locationPermissionHandler();
    if (result != Operation.success) return;
    await setPickUpAddress();
    if (!mounted) return;
    Navigator.of(context).pop();
    scaffoldKey.currentState!.showBottomSheet(
      (context) => SearchFieldBottomSheet(
        searchController: searchController,
        rideDetailCallBack: getRideDetails,
      ),
      enableDrag: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Values.radius30)),
      ),
    );
    setState(() {});
  }

  void changeThemeMode(value) {
    setState(() => isDarkMode = value);
    if (value) {
      AdaptiveTheme.of(context).setDark();
      _googleMapController!.setMapStyle(Values.googleMapStyleDark);
      darkStatusAndNavigationBar();
    } else {
      AdaptiveTheme.of(context).setLight();
      _googleMapController!.setMapStyle(Values.googleMapStyleLight);
      lightStatusAndNavigationBar();
    }
  }

  Future<void> getRideDetails() async {
    if (searchController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select a destination address');
      return;
    }
    try {
      final pickUp = Provider.of<AddressProvider>(context, listen: false).pickUpAddress;
      final destination = Provider.of<AddressProvider>(context, listen: false).destinationAddress;
      final startPos = LatLng(pickUp!.latitude, pickUp.longitude);
      final endPos = LatLng(destination!.latitude, destination.longitude);
      showLoadingDialog(context: context, text: 'Loading...');
      final rideDetails = await HomePageServices.getRideDetails(startPos: startPos, endPos: endPos);
      if (!mounted) return;
      Navigator.of(context).pop();
      if (rideDetails == Operation.failed) return;

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> results = polylinePoints.decodePolyline(rideDetails.encodedPoints);

      if (results.isEmpty) return;

      polyLineCoordinates.clear();
      for (var element in results) {
        polyLineCoordinates.add(LatLng(element.latitude, element.longitude));
      }
      polyLines.clear();
      Polyline polyline = Polyline(
        polylineId: const PolylineId('polyid'),
        color: Colors.orange,
        points: polyLineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polyLines.add(polyline);
      LatLngBounds bounds;
      if (startPos.latitude > endPos.latitude && startPos.longitude > endPos.longitude) {
        bounds = LatLngBounds(southwest: endPos, northeast: startPos);
      } else if (startPos.longitude > endPos.longitude) {
        bounds = LatLngBounds(
          southwest: LatLng(startPos.latitude, endPos.longitude),
          northeast: LatLng(endPos.latitude, startPos.longitude),
        );
      } else if (startPos.latitude > endPos.latitude) {
        bounds = LatLngBounds(
          southwest: LatLng(endPos.latitude, startPos.longitude),
          northeast: LatLng(startPos.latitude, endPos.longitude),
        );
      } else {
        bounds = LatLngBounds(southwest: startPos, northeast: endPos);
      }
      _googleMapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

      Marker startMarker = Marker(
        markerId: const MarkerId('start'),
        position: startPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Pickup Address', snippet: pickUp.placeName),
      );

      Marker endMarker = Marker(
        markerId: const MarkerId('end'),
        position: endPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Destination Address', snippet: destination.placeName),
      );

      markers.addAll({startMarker, endMarker});
      setState(() {});
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        barrierColor: Colors.black26,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Values.radius30),
          ),
        ),
        builder: (context) => RideDetailsBottomSheet(
          onCloseButtonPressed: () {
            setState(() {
              polyLineCoordinates.clear();
              markers.clear();
              polyLines.clear();
              circles.clear();
              searchController.text = '';
            });
            Navigator.of(context).pop();
          },
          rideDetails: rideDetails,
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Please select destination first.',
        backgroundColor: Colors.orangeAccent,
        textColor: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.85),
        elevation: 0,
        title: Text(FirebaseServices.getCurrentUser()!.email!),
      ),
      drawer: MyDrawer(
        child: DayNightSwitcher(
          dayBackgroundColor: Coloors.darkBg.withOpacity(0.3),
          nightBackgroundColor: Coloors.darkBg,
          isDarkModeEnabled:
              isDarkMode ?? Theme.of(context).brightness == Brightness.dark ? true : false,
          onStateChanged: changeThemeMode,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.6039067, 37.4649089),
              zoom: 15,
            ),
            buildingsEnabled: false,
            compassEnabled: true,
            myLocationEnabled: true,
            padding: EdgeInsets.only(bottom: bottomPadding),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            circles: circles,
            markers: markers,
            polylines: polyLines,
            onMapCreated: onMapCreated,
            onTap: setDestinationAddress,
          ),
          Positioned(
            bottom: 365.h,
            right: Values.width20,
            child: Material(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Values.radius15),
              child: InkWell(
                onTap: () {
                  LatLng pos = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
                  _googleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: pos, zoom: 15),
                    ),
                  );
                },
                splashFactory: NoSplash.splashFactory,
                borderRadius: BorderRadius.circular(Values.radius15),
                child: Padding(
                  padding: EdgeInsets.all(Values.height10),
                  child: const Icon(
                    Icons.my_location_outlined,
                    color: Coloors.whiteBg,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  openDrawer() => scaffoldKey.currentState!.openDrawer();
}

class RideDetailsBottomSheet extends StatelessWidget {
  final VoidCallback onCloseButtonPressed;
  final RideDetailsModel rideDetails;
  const RideDetailsBottomSheet({
    Key? key,
    required this.onCloseButtonPressed,
    required this.rideDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360.h,
      padding: EdgeInsets.symmetric(
        horizontal: Values.width20,
        vertical: Values.height10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Values.radius30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(
                text: 'Select your taxi',
                fontSize: 18,
              ),
              IconButton(
                onPressed: onCloseButtonPressed,
                icon: const Icon(
                  Icons.close_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Image.network(
            'https://content.jdmagicbox.com/quickquotes/images_main/tvs-three-wheelers-15-01-2021-021-220038788-p7594.png',
            height: 120.h,
            width: 160.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const MyText(
                      text: 'Distance: ',
                      textColor: Colors.grey,
                      fontSize: 12,
                    ),
                    MyText(
                      text: rideDetails.distanceText,
                      textColor: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const MyText(
                      text: 'Price: ',
                      textColor: Colors.grey,
                      fontSize: 12,
                    ),
                    MyText(
                      text: '${HomePageServices.estimateFares(rideDetails)} Birr',
                      textColor: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const MyText(
                      text: 'Approximate time: ',
                      textColor: Colors.grey,
                      fontSize: 12,
                    ),
                    MyText(
                      text: rideDetails.durationText,
                      textColor: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const MyText(
                      text: 'Payment type: ',
                      textColor: Colors.grey,
                      fontSize: 12,
                    ),
                    MyText(
                      text: 'Cash',
                      textColor: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          MyElevatedButton(
            child: const MyText(
              text: 'Request a Ride',
              textColor: Coloors.whiteBg,
            ),
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                barrierColor: Colors.black26,
                isDismissible: false,
                enableDrag: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Values.radius30),
                  ),
                ),
                builder: (context) {
                  return Container(
                    height: 180.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: Values.width20,
                      vertical: Values.height10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Values.radius30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LinearProgressIndicator(
                          color: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey[200],
                        ),
                        const MyText(text: 'Requesting a Ride...', fontSize: 20),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                            const MyText(
                              text: 'Cancel Ride',
                              fontFamily: 'Bolt-Reg',
                              fontSize: 13,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
