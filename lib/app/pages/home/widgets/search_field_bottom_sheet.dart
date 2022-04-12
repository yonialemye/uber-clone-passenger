import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../exports/constants.dart';
import '../../../exports/widgets.dart';

class SearchFieldBottomSheet extends StatelessWidget {
  const SearchFieldBottomSheet({
    Key? key,
    required this.searchController,
    required this.rideDetailCallBack,
  }) : super(key: key);

  final TextEditingController searchController;
  final VoidCallback rideDetailCallBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360.h,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Values.radius30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              onPressed: rideDetailCallBack,
              child: const Text('Calculate distance'),
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
                icon: const Icon(Icons.add_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          Card(
            elevation: 4,
            color: Theme.of(context).scaffoldBackgroundColor,
            margin: EdgeInsets.zero,
            child: const ListTile(
              title: Text('Home'),
              subtitle: Text('Gondar Arada'),
              trailing: Icon(Icons.edit),
            ),
          ),
          // SizedBox(height: Values.height20),
        ],
      ),
    );
  }
}
