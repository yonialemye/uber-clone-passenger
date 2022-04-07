import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
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

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchController = TextEditingController();
  double bottomPadding = 0;
  bool? isDarkMode;

  @override
  void didChangeDependencies() {
    getSavedThemeMode();
    isDarkMode == true ? darkStatusAndNavigationBar() : lightStatusAndNavigationBar();
    super.didChangeDependencies();
  }

  getSavedThemeMode() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    setState(() {
      if (savedThemeMode == AdaptiveThemeMode.dark) {
        isDarkMode = true;
        _googleMapController!.setMapStyle(Values.googleMapStyle);
      } else {
        isDarkMode = false;
        _googleMapController!.setMapStyle('''[]''');
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              _googleMapController!.setMapStyle(Values.googleMapStyle);
            } else {
              AdaptiveTheme.of(context).setLight();
              _googleMapController!.setMapStyle('''[]''');
            }
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            buildingsEnabled: false,
            compassEnabled: true,
            myLocationEnabled: true,
            padding: EdgeInsets.only(bottom: bottomPadding),
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _googleMapController = controller;
              getSavedThemeMode();
              setState(() => bottomPadding = 365);
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
                      MyElevatedButton(child: const Text('Calculate distance'), onPressed: () {}),
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
