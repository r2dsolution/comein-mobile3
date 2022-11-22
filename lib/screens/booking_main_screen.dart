import 'dart:convert';

import 'package:thecomein/components/booking_card.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/constants.dart';
import 'package:thecomein/helper/comein_api.dart';
import 'package:thecomein/models/hotel_profile.dart';

import 'package:flutter/material.dart';

import 'package:getwidget/getwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:thecomein/routes.dart';

class MainBookingScreen extends StatelessWidget {
  static String routeName = ROUTE_NAME_MAIN_BOOKING;

  const MainBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final setting = ModalRoute.of(context)!.settings;
    bool isHotel = true;
    if (setting.arguments != null) {
      Map params = setting.arguments as Map;
      if (params.containsKey('hotel')) {
        isHotel = false;
      }
      ;
    }
    ;

    int bookingSize = 0; //= hotelBooks.length + tourBooks.length;

    return HotelBookingUserScreen(
      titleText: 'Good Morning',
      messages: (bookingSize == 0)
          ? "No bookings"
          : "You have ${bookingSize} bookings.",

      // isHotelBooking: isHotel,
    );
  }
}

class HotelBookingUserScreen extends DefaultUserScreen {
  final String titleText;
  // final bool isHotelBooking;
  final String messages;

  HotelBookingUserScreen({
    Key? key,
    required this.titleText,
    required this.messages,
  }) : super(
            key: key,
            menu: MenuState.home,
            title: titleText,
            titleWidget: Container(
              // color: Colors.red,
              alignment: Alignment(0.0, 1.0),
              height: 90,
              child: Text(messages),
            ));

  @override
  State<StatefulWidget> createState() {
    return _HotelBookingUserScreenState();
  }
}

class _HotelBookingUserScreenState
    extends DefaultUserScreenState<HotelBookingUserScreen> {
  String searchQuery = '';
  final searchController = FloatingSearchBarController();
  String booknoQuery = '';
  List<HotelBooking> hotelbooks = [];
  List<TourBooking> tourbooks = [];

  @override
  void initState() {
    doListHotelBooking().then((value) {
      setState(() {
        hotelbooks = value;
      });
    });
    doListTourBooking().then((value) {
      setState(() {
        tourbooks = value;
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) => doNotify(context));
  }

  doNotify(BuildContext context) async {
    List<HotelBooking> notifyBook = await doNotifyHotelBooking();
    if (!notifyBook.isEmpty) {
      int i = notifyBook.length;
      List<int> idList = notifyBook.map((book) => book.id).toList();
      // List<String> idList = notifyBook.map(s->doId(s)).toList();
      YesNoAlert(
          context: context,
          message: 'You have new ${i} booking',
          onYES: () => {
                Navigator.pop(context),
                initNotifyBook(idList),
              },
          onNO: () => {Navigator.pop(context)});
    }
  }

  initNotifyBook(List<int> idList) async {
    onLoading(true);
    String url = '/hotel-bookings/init';
    String idValue = jsonEncode(idList);
    String content = '{"id-list":${idValue}}';
    // jsonEncode(idList);
    print('url=${url}');
    print('content=${content}');
    String jsonStr = await ComeInAPI.post(url, content);
    onLoading(false);
    Navigator.pushReplacementNamed(context, ROUTE_NAME_MAIN_BOOKING);
  }

  doSearch(String bookno) {
    // setState(() {
    //   this.searchQuery = bookno;
    // });

    print('select->${bookno}');
    this.searchController.close();
    this.searchController.query = bookno;
    setState(() {
      this.booknoQuery = bookno;
    });
  }

  doCancel(String _bookno) async {
    Navigator.pop(context);
    onLoading(true);
    String url = '/hotel-bookings/cancel-forward';
    String content = '{}';
    Map<String, String> params = {'bookno': _bookno};
    String jsonStr = await ComeInAPI.postQuery(url, content, params);
    print('cancel-result :' + jsonStr);
    Navigator.pushNamed(context, ROUTE_NAME_MAIN_BOOKING);
    onLoading(false);
  }

  List<ListTile> buildSearchResult(
      List<HotelBooking> h, List<TourBooking> t, String query) {
    String q = query.toUpperCase();
    List<ListTile> b1 = h
        .where((b) => (b.bookNO.startsWith(q) ||
            b.hotel.address.toUpperCase().contains(q) ||
            b.hotel.name.toUpperCase().contains(q)))
        .map((b) => ListTile(
              onTap: () => {
                doSearch(b.bookNO),
              },
              leading: Icon(FontAwesomeIcons.bed),
              subtitle: Text("${b.hotel.name} - ${b.hotel.address}"),
              title: Text(b.bookNO),
            ))
        .toList();
    List<ListTile> b2 = t
        .where((b) => (b.bookNO.toUpperCase().startsWith(q) ||
            b.tour.address.toUpperCase().contains(q) ||
            b.tour.name.toUpperCase().contains(q)))
        .map((b) => ListTile(
              onTap: () => {
                doSearch(b.bookNO),
              },
              leading: Icon(FontAwesomeIcons.suitcaseRolling),
              subtitle: Text("${b.tour.name} - ${b.tour.address}"),
              title: Text(b.bookNO),
            ))
        .toList();
    b1.addAll(b2);
    return b1;
  }

  List<BookingCard> buildBookingCard(
      List<HotelBooking> h, List<TourBooking> t, String q) {
    List<BookingCard> b1 = h
        .where((b) => (q == '') || (b.bookNO == q))
        .map((b) => BookingCard(
              bookDate: b.checkInDate,
              checkOutDate: b.checkOutDate,
              target: (b.customer2 == null ? '' : b.customer2),
              //target: '',
              hotel: b.hotel,
              bookno: b.bookNO,
              onDetailEvent: () {
                Navigator.pushNamed(context, ROUTE_NAME_DETAIL_HOTEL_BOOKING,
                    arguments: {"booking_no": b.bookNO, "tabIndex": 0});
              },
              onShareEvent: () {
                Navigator.pushNamed(context, ROUTE_NAME_FORWARD_HOTEL_BOOKING,
                    arguments: {"booking_no": b.bookNO});
              },
              onCancelEvent: () => doCancel(b.bookNO),
            ))
        .toList();
    List<BookingCard> b2 = t
        .where((b) => (q == '') || (b.bookNO == q))
        .map((b) => BookingCard(
              bookDate: null,
              target: '',
              // hotel: HotelProfile(b.tour.shortName, b.tour.name, b.tour.address,
              //     b.tour.assetImages),
              tour: b.tour,
              bookno: b.bookNO,
              onDetailEvent: () {
                Navigator.pushNamed(context, 'ROUTE_NAME_DETAIL_TOUR_BOOKING',
                    arguments: {
                      "booking_no": b.bookNO,
                    });
              },
              onShareEvent: () {},
              onCancelEvent: () {},
            ))
        .toList();
    b1.addAll(b2);
    return b1;
  }

  @override
  Widget searchBody(BuildContext context) {
    // this.searchController.query = searchQuery;
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
            print('query=${query}');
            setState(() {
              if (query == '') {
                this.booknoQuery = '';
              }
              this.searchQuery = query;
            });
          },
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      buildSearchResult(hotelbooks, tourbooks, searchQuery),
                ),
              ),
            );
          }),
    );
  }

  Future<List<HotelBooking>> doListHotelBooking() async {
    onLoading(true);
    String endpoint = '/hotel-bookings';
    String jsonStr = await ComeInAPI.post(endpoint, '{}');
    print('json->: ${jsonStr}');
    Map<String, dynamic> json = jsonDecode(jsonStr);
    Map<String, dynamic> resultMap = {};
    if (json.containsKey('result')) {
      resultMap = json['result'];
    }

    List list = [];
    if (resultMap.containsKey('hotel-booking')) {
      list = resultMap['hotel-booking'] as List;
    }
    // List<HotelBooking> results = List.from(list);

    List<HotelBooking> dataList =
        list.map((json) => HotelBooking.fromJson(json)).toList();

    onLoading(false);
    return dataList;
  }

  Future<List<TourBooking>> doListTourBooking() async {
    TourProfile p = TourProfile('T', 'S Tour', 'BKK');
    TourBooking t = TourBooking('bookNO', DateTime(2022), p);
    List<TourBooking> dataList = [t];

    return dataList;
  }

  Future<List<HotelBooking>> doNotifyHotelBooking() async {
    onLoading(true);
    String jsonStr = await ComeInAPI.post('/hotel-bookings/notify', '{}');
    print('json->: ${jsonStr}');
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    if (jsonMap.containsKey('result')) {
      Map<String, dynamic> resultMap = jsonMap['result'];
      if (resultMap.containsKey('hotel-booking')) {
        List list = resultMap['hotel-booking'] as List;
        List<HotelBooking> dataList =
            list.map((json) => HotelBooking.fromJson(json)).toList();
        print('notify-size: ${dataList.length}');
        onLoading(false);
        return dataList;
      }
    }
    onLoading(false);
    return [];

    // List<HotelBooking> results = List.from(list);
  }

  @override
  Widget buildBody(BuildContext context) {
    bool isPortrait = true;
    // List<Widget> items = [hotel2Card(), hotel2Card()];
    //return noCard();
    // return widget.isHotelBooking ? hotel2Card() : noCard();
    return Column(
      children: buildBookingCard(hotelbooks, tourbooks, this.booknoQuery),
    );
  }

  noCard() {
    return GFCard(
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      showOverlayImage: true,
      imageOverlay: AssetImage(
        'assets/images/travel.jpeg',
      ),
      // title: GFListTile(
      //   //color: Colors.red,
      //   // avatar: GFAvatar(),
      //  // titleText: 'You have no upcomming ticket',
      //   //subTitleText: 'PlayStation 4',
      // ),
      // content: Text("You have no upcomming ticket"),
      content: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 150),
        child: Text(
          " You have no upcomming booking. ",
          style: TextStyle(
              fontSize: 17.0,
              backgroundColor: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  hotel1Card() {
    return GFCard(
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      showOverlayImage: true,
      imageOverlay: AssetImage(
        'assets/images/travel.jpeg',
      ),
      // title: GFListTile(
      //   //color: Colors.red,
      //   // avatar: GFAvatar(),
      //  // titleText: 'You have no upcomming ticket',
      //   //subTitleText: 'PlayStation 4',
      // ),
      // content: Text("You have no upcomming ticket"),
      content: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 150),
        child: Text(
          " You have no upcomming booking. ",
          style: TextStyle(
              fontSize: 17.0,
              backgroundColor: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
