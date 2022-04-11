import 'package:flutter/material.dart';

import '../../../exports/constants.dart';
import '../../../exports/widgets.dart';

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
