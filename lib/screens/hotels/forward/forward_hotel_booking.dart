import 'dart:convert';

import 'package:thecomein/components/booking_card.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/helper/comein_api.dart';
import 'package:thecomein/models/hotel_profile.dart';
import 'package:thecomein/routes.dart';
import 'package:flutter/material.dart';

class ForwardHotelBookingScreen extends StatelessWidget {
  static String routeName = ROUTE_NAME_FORWARD_HOTEL_BOOKING;

  const ForwardHotelBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    String bookNO = params['booking_no'];
    return ForwardHotelBookingUserScreen(
      bookNO: bookNO,
      titleText: 'Hotel Booking - ' + bookNO,
    );
  }
}

class ForwardHotelBookingUserScreen extends DefaultNavigatorScreen {
  final String titleText;
  final String bookNO;
  // = HotelBooking('', '', null, 0, DateTime.now());

  const ForwardHotelBookingUserScreen(
      {Key? key, required this.bookNO, required this.titleText})
      : super(key: key, title: titleText);

  @override
  State<StatefulWidget> createState() {
    return _ForwardHotelBookingUserScreen();
  }
}

class _ForwardHotelBookingUserScreen
    extends DefaultNavigatorScreenState<ForwardHotelBookingUserScreen> {
  //late HotelBooking bookingInfo = HotelBooking();
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  String checkIn = '-';
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) => doInitScreen(context));
  }

  @override
  Widget buildBody(BuildContext context) {
    Color tColor = Colors.white10;
    return Column(children: [
      // ListTile(
      //   dense: true,
      //   tileColor: tColor,
      //   leading: Text("เลขที่การจอง"),
      //   trailing: Text(bookingInfo.bookNO),
      // ),
      // ListTile(
      //   dense: true,
      //   tileColor: tColor,
      //   leading: Text("ผู้จอง"),
      //   trailing: Text(bookingInfo.customer),
      // ),
      // ListTile(
      //   dense: true,
      //   tileColor: tColor,
      //   leading: Text("โรงแรม"),
      //   trailing: Text(bookingInfo.hotel.name),
      // ),
      // ListTile(
      //   dense: true,
      //   tileColor: tColor,
      //   leading: Text("ที่อยู่"),
      //   trailing: Text(bookingInfo.hotel.address),
      // ),
      // ListTile(
      //   dense: true,
      //   tileColor: tColor,
      //   leading: Text("วันที่เข้าพัก"),
      //   trailing: Text(checkIn),
      // ),
      HotelBookingShortCard(
        onHotelBookInit: doHotelBooking,
        onLoad: onLoading,
        bookno: widget.bookNO,
      ),
      const SizedBox(
        height: 20,
      ),
      // GFCard(
      //   content:
      ListTile(
        dense: true,
        tileColor: tColor,
        title: const Text("Send booking to Other.",
            style: TextStyle(fontSize: 20)),
        subtitle: Column(children: [
          const SizedBox(
            height: 30,
          ),
          EmailTextFeild(textController: emailController),
          DefaultTextFeild(
            textController: nameController,
            svgIcon: "assets/icons/User.svg",
            hintLabel: 'fullname',
            textLabel: 'name-surname',
            // changeEvent: (_value) => {
            //   if (_value!.isNotEmpty)
            //     {
            //       removeError(error: appLocale.last_name_required),
            //     }
            // },
            // validateEvent: (_value) {
            //   if (_value!.isEmpty) {
            //     addError(error: appLocale.last_name_required);
            //     return "";
            //   }
            //   return null;
            // },
          ),
          DefaultButton(text: 'send to', press: forwardBooking
              // () async {
              //   onLoading(true);
              //   String url = '/hotel-bookings/forward';
              //   Map<String, String> params = {'bookno': widget.bookNO};
              //   String _email = emailController.text;
              //   String _name = nameController.text;
              //   String content = '{"email":"${_email}","name":"${_name}"}';
              //   await ComeInAPI.postQuery(url, content, params);
              //   onLoading(false);
              // Navigator.pushNamed(
              //   context,
              //   ROUTE_NAME_MAIN_BOOKING,
              // );
              //}
              )
        ]),
      ),
      // ),
    ]);
  }

  forwardBooking() {
    print('before forward');
    onLoading(true);
    // AmplifyConfig().init(context);
    String _email = emailController.text;
    String _name = nameController.text;
    String _bookno = widget.bookNO;
    Future.delayed(
      loadingTimes,
      () async => {
        doForward(_bookno, _email, _name),
        print('forward completed'),
        onLoading(false),
      },
    );
  }

  doForward(String _bookno, String _email, String _name) async {
    String url = '/hotel-bookings/forward';
    Map<String, String> params = {'bookno': _bookno};
//    String _email = emailController.text;
//    String _name = nameController.text;
    String content = '{"email":"${_email}","name":"${_name}"}';
    await ComeInAPI.postQuery(url, content, params);
  }

  // doInitScreen(BuildContext context) {
  //   onLoading(true);

  //   Future.delayed(
  //     loadingTimes,
  //     () async => {
  //       onLoading(false),
  //       setState(() {
  //         bookingInfo = initBookingInfo(context);
  //         checkIn = bookingInfo.checkInDate.toString();
  //       }),
  //       print('load..init finish'),
  //     },
  //   );
  // }

  Future<HotelBooking> doHotelBooking(
      BuildContext context, String _bookno) async {
    print('book-no: ${_bookno}');
    // if (_bookno == '') {
    String url = '/hotel-bookings/view';
    Map<String, String> params = {'bookno': _bookno};
    String jsonStr = await ComeInAPI.postQuery(url, '{}', params);
    print('json->: ${jsonStr}');
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    dynamic json = jsonMap['result'];
    return HotelBooking.fromJson(json);

    //}
  }
  // HotelBooking initBookingInfo(BuildContext context) {
  //   final params = ModalRoute.of(context)!.settings.arguments as Map;
  //   String bookNO = params['booking_no'];
  //   HotelProfile h = new HotelProfile(
  //       "JH", "Jaroon Hotel", 'Bangkok, TH.', 'assets/images/hotel01.jpeg');
  //   HotelBooking book = new HotelBooking(
  //       bookNO: bookNO,
  //       customer: "tawatchai radom",
  //       hotel: h,
  //       visitor: 0,
  //       checkInDate: DateTime.now());
  //   return book;
  // }

  // HotelBooking defaultBooking() {
  //   HotelProfile p = HotelProfile(); //"", "", '', 'assets/image/hotel01.jpeg');
  //   HotelBooking b =
  //       HotelBooking(bookNO: '', hotel: p, checkInDate: DateTime.now());
  //   return b;
  // }
}

class BookingDataRow extends StatelessWidget {
  final HotelProfile hotel;
  final HotelBooking bookInfo;

  const BookingDataRow({Key? key, required this.hotel, required this.bookInfo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: const Text("ผู้จอง"),
        trailing: Text(bookInfo.customer),
      )
    ]);
  }
}

class DataRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2, // 60% of space => (6/(6 + 4))
            child: Container(
              // color: Colors.red,
              child: const Text(
                "Hotel Booking",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1, // 60% of space => (6/(6 + 4))
            child: Container(
              //color: Colors.red,
              alignment: Alignment.centerRight,
              //color: Colors.red,
              child: Text("CI8398"),
            ),
          ),
        ]);
  }
}
