import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_passenger/app/exports/constants.dart';
import 'package:uber_clone_passenger/app/exports/helpers.dart';
import 'package:uber_clone_passenger/app/exports/widgets.dart';

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

  final CameraPosition _piassaGondar = const CameraPosition(
    target: LatLng(12.6039067, 37.4649089),
    zoom: 17,
  );

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchController = TextEditingController();
  double bottomPadding = 0;
  bool? isDarkMode;
  Position? _currentPosition;

  Set<Circle> circles = {};

  animateCameraPosition({latitude, longitude}) {
    LatLng pos = LatLng(latitude, longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 15);
    _googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(cp),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getPickUpAddress() async {
    final result = await HomePageServices.locationPermissionHandler();
    if (result != Operation.success) return;
    _currentPosition = await Geolocator.getCurrentPosition();
    animateCameraPosition(
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
    );
    final address = await HomePageServices.findCoordinateAddress(
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      context: context,
      mounted: mounted,
    );
    if (mounted) Provider.of<AddressProvider>(context, listen: false).setPickUpAddress(address);
  }

  void getDestinationAddress() {}

  void getCurrentAddress() async {
    final result = await HomePageServices.locationPermissionHandler();
    if (result != Operation.success) return;
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    animateCameraPosition(
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
    );
    final address = await HomePageServices.findCoordinateAddress(
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      context: context,
      mounted: mounted,
    );
    if (mounted) Provider.of<AddressProvider>(context, listen: false).setPickUpAddress(address);
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    showLoadingDialog(context: context, text: 'Loading...');
    _controller.complete(controller);
    _googleMapController = controller;
    if (Theme.of(context).brightness == Brightness.dark) {
      _googleMapController!.setMapStyle(Values.googleMapStyleDark);
    } else {
      _googleMapController!.setMapStyle(Values.googleMapStyleLight);
    }
    setState(() => bottomPadding = 365);
    getCurrentAddress();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.of(context).pop();
    if (mounted) {
      scaffoldKey.currentState!.showBottomSheet(
        (context) {
          return SearchFieldBottomSheet(
            searchController: searchController,
          );
        },
        enableDrag: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Values.radius30),
          ),
        ),
      );
    }
  }

  Future<void> onMapTap(LatLng position) async {
    showLoadingDialog(context: context, barrierColor: Colors.black12, text: 'Loading...');
    final address = await HomePageServices.findCoordinateAddress(
      latitude: position.latitude,
      longitude: position.longitude,
      context: context,
      mounted: mounted,
    );
    if (!mounted) return;
    animateCameraPosition(latitude: position.latitude, longitude: position.longitude);
    Navigator.of(context).pop();
    Provider.of<AddressProvider>(context, listen: false).setDestinationAddress(address);

    searchController.text = Provider.of<AddressProvider>(
      context,
      listen: false,
    ).destinationAddress!.placeName;

    setState(() {
      circles.add(Circle(
        circleId: const CircleId('destId'),
        center: position,
        radius: 20,
        strokeColor: Colors.red,
        fillColor: Colors.red,
        strokeWidth: 3,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: MyDrawer(
        child: DayNightSwitcher(
          dayBackgroundColor: Coloors.darkBg.withOpacity(0.3),
          nightBackgroundColor: Coloors.darkBg,
          isDarkModeEnabled:
              isDarkMode ?? Theme.of(context).brightness == Brightness.dark ? true : false,
          onStateChanged: (value) {
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
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _piassaGondar,
            buildingsEnabled: false,
            compassEnabled: true,
            myLocationEnabled: true,
            padding: EdgeInsets.only(bottom: bottomPadding),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            circles: circles,
            onMapCreated: onMapCreated,
            onTap: onMapTap,
          ),
          Positioned(
            top: Values.height50,
            left: Values.width20,
            child: Material(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Values.radius15),
              child: InkWell(
                onTap: openDrawer,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(Values.radius15),
                child: Padding(
                  padding: EdgeInsets.all(Values.height10),
                  child: const Icon(
                    Icons.segment,
                    color: Coloors.whiteBg,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 380,
            right: Values.width20,
            child: Material(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Values.radius15),
              child: InkWell(
                onTap: () async {
                  showLoadingDialog(context: context, text: 'Loading...');
                  await getPickUpAddress();
                  if (!mounted) return;
                  Navigator.of(context).pop();
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

class SearchFieldBottomSheet extends StatelessWidget {
  const SearchFieldBottomSheet({Key? key, required this.searchController}) : super(key: key);

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Values.radius30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Values.height10),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  Values.radius30,
                ),
              ),
            ),
          ),
          SizedBox(height: Values.height10),
          MyText(
            text: 'Welcome back!',
            fontSize: 11,
            fontFamily: 'Pop-Regular',
            textColor: Theme.of(context).textTheme.bodyText2!.color,
          ),
          SizedBox(height: Values.height10),
          MyText(
            text: 'Where do you want to go?',
            fontSize: 16,
            textColor: Theme.of(context).textTheme.bodyText2!.color,
          ),
          SizedBox(height: Values.height20),
          MyTextField(
            controller: searchController,
            labelText: 'Select location from map',
            prefixIcon: Icons.location_on_outlined,
            readOnly: true,
            keyBoardType: TextInputType.text,
            hintText: 'Hey',
          ),
          SizedBox(height: Values.height20),
          Hero(
            tag: ButtonsHero.elevated,
            child: MyElevatedButton(
              child: const Text('Calculate distance'),
              onPressed: () {},
            ),
          ),
          SizedBox(height: Values.height20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: 'Favorite Places',
                textColor: Theme.of(context).textTheme.bodyText2!.color,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Card(
            elevation: 4,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const ListTile(
              title: Text('Home'),
              subtitle: Text('Gondar Arada'),
              trailing: Icon(Icons.edit),
            ),
          ),
          SizedBox(height: Values.height20),
        ],
      ),
    );
  }
}
