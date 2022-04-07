import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_passenger/app/exports/constants.dart';
import 'package:uber_clone_passenger/app/exports/widgets.dart';

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

  String? mapStyle;

  final TextEditingController searchController = TextEditingController();
  double bottomPadding = 0;

  @override
  void didChangeDependencies() {
    mapStyle =
        Theme.of(context).primaryColor == Coloors.blueLight ? '''[]''' : Values.googleMapStyle;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _googleMapController!.setMapStyle(mapStyle);
              setState(() {
                bottomPadding = 365;
              });
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10, right: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      color: Coloors.whiteBg,
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                ),
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
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      Card(
                        color: Coloors.blueDark.withOpacity(0.1),
                        elevation: 0,
                        child: const ListTile(
                          title: Text('Home'),
                          subtitle: Text('Gondar Arada'),
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
}
