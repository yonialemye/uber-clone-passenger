import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_passenger/app/exports/constants.dart';
import 'package:uber_clone_passenger/app/exports/widgets.dart';

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

  @override
  void didChangeDependencies() {
    getSavedThemeMode();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  getSavedThemeMode() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    setState(() {
      if (savedThemeMode == AdaptiveThemeMode.dark) {
        isDarkMode = true;
      } else {
        isDarkMode = false;
      }
      isDarkMode == true ? darkStatusAndNavigationBar() : lightStatusAndNavigationBar();
    });
  }

  void getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    LatLng pos = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    CameraPosition cp = CameraPosition(target: pos, zoom: 17);
    _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: MyDrawer(
        child: DayNightSwitcher(
          dayBackgroundColor: Coloors.darkBg.withOpacity(0.3),
          nightBackgroundColor: Coloors.darkBg,
          isDarkModeEnabled: isDarkMode ?? false,
          onStateChanged: (value) {
            setState(() => isDarkMode = value);
            if (value) {
              AdaptiveTheme.of(context).setDark();
              _googleMapController!.setMapStyle(Values.googleMapStyleDark);
            } else {
              AdaptiveTheme.of(context).setLight();
              _googleMapController!.setMapStyle(Values.googleMapStyleLight);
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
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _googleMapController = controller;
              if (isDarkMode!) {
                _googleMapController!.setMapStyle(Values.googleMapStyleDark);
              } else {
                _googleMapController!.setMapStyle('''[]''');
              }
              setState(() => bottomPadding = 365);
              getCurrentPosition();
            },
          ),
          Positioned(
            top: 50,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, right: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                onPressed: openDrawer,
                color: Coloors.whiteBg,
                icon: const Icon(Icons.menu),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Values.radius30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  openDrawer() => scaffoldKey.currentState!.openDrawer();
}