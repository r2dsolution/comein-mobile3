import 'package:flutter/cupertino.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/constants.dart';

class TourMainScreen extends StatelessWidget {
  const TourMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TitleWidget tWidget = const TitleWidget(title: "Tour");
    return TourBookingUserScreen(
        titleText: 'Tour', titleWidget: tWidget, messages: 'Tour - message');
  }
}

class TourBookingUserScreen extends DefaultUserScreen {
  final String titleText;
  final String messages;
  final Widget? titleWidget;

  const TourBookingUserScreen({
    Key? key,
    required this.titleText,
    required this.titleWidget,
    required this.messages,
  }) : super(
            key: key,
            menu: MenuState.tourBooking,
            title: titleText,
            titleWidget: titleWidget);

  @override
  State<StatefulWidget> createState() {
    return _TourBookingUserScreenState();
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

class _TourBookingUserScreenState
    extends DefaultUserScreenState<TourBookingUserScreen> {
  @override
  Widget buildBody(BuildContext context) {
    return const Text('Tour');
  }

  @override
  Widget searchBody(BuildContext context) {
    return const Text('search - tour');
  }
}
