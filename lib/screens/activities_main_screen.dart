import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/constants.dart';

class ActivitiesMainScreen extends StatelessWidget {
  const ActivitiesMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TitleWidget tWidget = const TitleWidget(title: "You have 3 activites.");
    return ActivitiesBoardUserScreen(
        titleText: 'History of activities',
        titleWidget: tWidget,
        messages: 'activities - message');
  }
}

class ActivitiesBoardUserScreen extends DefaultUserScreen {
  final String titleText;
  final String messages;
  final Widget? titleWidget;

  const ActivitiesBoardUserScreen({
    Key? key,
    required this.titleText,
    required this.titleWidget,
    required this.messages,
  }) : super(
            key: key,
            menu: MenuState.activities,
            title: titleText,
            titleWidget: titleWidget);

  @override
  State<StatefulWidget> createState() {
    return _ActivitiesBoardUserScreenState();
  }
}

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      alignment: const Alignment(0.0, 1.0),
      height: 90,
      child: Text(title),
    );
  }
}

class _ActivitiesBoardUserScreenState
    extends DefaultUserScreenState<ActivitiesBoardUserScreen> {
  final searchController = FloatingSearchBarController();
  @override
  Widget buildBody(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: buildActivities(),
      ),
    );
  }

  @override
  Widget searchBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: FloatingSearchBar(
          clearQueryOnClose: false,
          controller: searchController,
          automaticallyImplyBackButton: false,
          hint: 'Search',
          onQueryChanged: (query) {
            // Call your model, bloc, controller here.
            // print('query=${query}');
            // setState(() {
            //   if (query == '') {
            //     this.booknoQuery = '';
            //   }
            //   this.searchQuery = query;
            // });
          },
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(mainAxisSize: MainAxisSize.min, children: []
                    // buildSearchResult(hotelbooks, tourbooks, searchQuery),
                    ),
              ),
            );
          }),
    );
    ;
  }

  buildActivities() {
    return [
      // const SizedBox(
      //   height: 30,
      // ),
      const GFListTile(
        titleText: 'Tour Booking is paid by Google Play',
        subTitleText: 'payment no: 2384-2830',
        avatar: GFAvatar(
            child: FaIcon(
              FontAwesomeIcons.cartShopping,
              //color: (target == '') ? Colors.blue : Colors.grey,
              size: 16,
            ),
            shape: GFAvatarShape.standard),
        //  icon: Icon(Icons.favorite),
      ),
      const GFListTile(
        titleText: 'Tour Booking is booked',
        subTitleText: 'booking no: MW3927',
        avatar: GFAvatar(
            child: FaIcon(
              FontAwesomeIcons.suitcaseRolling,
              //color: (target == '') ? Colors.blue : Colors.grey,
              size: 16,
            ),
            shape: GFAvatarShape.standard),
        //  icon: Icon(Icons.favorite),
      ),
      const GFListTile(
        titleText: 'Hotel Booking is confirmed',
        subTitleText: 'booking no: 2004114952',
        avatar: GFAvatar(
            child: FaIcon(
              FontAwesomeIcons.bed,
              //color: (target == '') ? Colors.blue : Colors.grey,
              size: 16,
            ),
            shape: GFAvatarShape.standard),
        //  icon: Icon(Icons.favorite),
      )
    ];
  }
}
