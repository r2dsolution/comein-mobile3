import 'dart:convert';

import 'package:thecomein/components/booking_card.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/keycard_detail.dart';
import 'package:thecomein/components/user_confirm_card.dart';
// import 'package:thecomein/components/keycard_detail.dart';
// import 'package:comein/components/user_confirm_card.dart';
import 'package:thecomein/helper/comein_api.dart';
import 'package:thecomein/models/hotel_profile.dart';
import 'package:thecomein/models/user_confirm.dart';
import 'package:thecomein/models/user_profile.dart';
// import 'package:comein/screens/hotel_booking/confirm_hotel_booking.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:tab_container/tab_container.dart';
import 'package:tab_container/tab_container.dart';
import 'package:thecomein/routes.dart';

class DetailHotelBookingScreen extends StatelessWidget {
  static String routeName = ROUTE_NAME_DETAIL_HOTEL_BOOKING;

  const DetailHotelBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    String _bookno = params['booking_no'];
    //int aIndex = params['tabIndex'] as int;
    return DetailHotelBookingNavScreen(
      titleText: 'Detail of Booking',
      bookno: _bookno,
      //   stepIndex: 0,
    );
  }
}

class DetailHotelBookingNavScreen extends DefaultNavigatorScreen {
  final String titleText;
  final String bookno;
  // final int stepIndex;

  const DetailHotelBookingNavScreen({
    Key? key,
    required this.titleText,
    required this.bookno,
    //  required this.stepIndex,
  }) : super(key: key, title: titleText);

  @override
  State<StatefulWidget> createState() {
    return _DetailHotelBookingNavScreen();
  }
}

class _DetailHotelBookingNavScreen
    extends DefaultNavigatorScreenState<DetailHotelBookingNavScreen> {
  TabContainerController _controller = TabContainerController(length: 3);

  HotelBooking? bookInfo; // = HotelBooking();
  UserInfo profile = UserInfo('', '', '', '');
  // String bookNO = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => doInitScreen(context));
  }

  doInitScreen(BuildContext c) async {
    final params = ModalRoute.of(context)!.settings.arguments as Map;

    UserInfo _profile = await ComeInAPI.profile();
    print('load default-profile by email: ${_profile.email}');
    setState(() {
      profile = _profile;
    });
    Future.delayed(
        loadingTimes,
        () async => {
              setState(() {
                if (params.containsKey('tabIndex')) {
                  int aIndex = params['tabIndex'] as int;
                  _controller.jumpTo(aIndex);
                }
              })
            });
    // String _bookno = params['booking_no'];
    // HotelBooking _bookInfo = await doHotelBooking(c, _bookno);
    // setState(() {
    //   bookNO = _bookno;
    //   bookInfo = _bookInfo;
    // });
  }

  Future<HotelBooking?> doHotelBooking(
      BuildContext context, String _bookno) async {
    print('data:  ${bookInfo}');
    if (bookInfo != null) {
      return bookInfo;
    } else {
      print('book-no: ${_bookno}');
      // if (_bookno == '') {
      String url = '/hotel-bookings/view';
      Map<String, String> params = {'bookno': _bookno};
      String jsonStr = await ComeInAPI.postQuery(url, '{}', params);
      print('json->: ${jsonStr}');
      Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      if (jsonMap.containsKey('result')) {
        dynamic json = jsonMap['result'];
        HotelBooking _bookInfo = HotelBooking.fromJson(json);
        print('customer: ${_bookInfo.customer}');
        setState(() {
          bookInfo = _bookInfo;
        });
        return _bookInfo;
      }

      return null;
    }

    //}
  }

  Future<HotelBooking> doConfirmBookingKYCInfo(BuildContext context,
      String _bookno, String ref_id, String ref_type) async {
    print('bookno: ${_bookno}');
    String url = '/kyc-hotel-bookings/add-kyc';
    Map<String, String> params = {'bookno': _bookno};
    String content = '{"card-id":"${ref_id}", "card-type":"${ref_type}"}';
    String jsonStr = await ComeInAPI.postQuery(url, content, params);
    print('json->: ${jsonStr}');
    HotelBooking _bookInfo = jsonStr2HotelBooking(jsonStr);
    setState(() {
      bookInfo = _bookInfo;
    });

    return _bookInfo;
  }

  HotelBooking jsonStr2HotelBooking(String jsonStr) {
    // UserConfirm c = UserConfirm.from(profile);
    // c.isDelete = false;

    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    //Map<String, dynamic> resultJSON = jsonMap['result'];
    //dynamic _bookJSON = resultJSON['hotel-booking'];
    dynamic _bookJSON = jsonMap['result'];

    print('load hotel-booking');
    return json2HotelBooking(_bookJSON);
  }

  HotelBooking json2HotelBooking(dynamic _bookJSON) {
    String jsonStr = jsonEncode(_bookJSON).toString();
    print('json-str: ${jsonStr}');
    //  dynamic _bookJSON = resultJSON['hotel-booking'];
    HotelBooking _UpdateBookInfo = HotelBooking.fromJson(_bookJSON);
    //  _UpdateBookInfo.initUserConfirm(c);
    _UpdateBookInfo.addUserConfirm(_bookJSON);
    print('return update book-info ${_UpdateBookInfo.kycCardId}');
    return _UpdateBookInfo;
  }

  Future<HotelBooking> doDeleteBookingKYCInfo(BuildContext context,
      String _bookno, String ref_id, String ref_type) async {
    print('bookno: ${_bookno}');
    String url = '/kyc-hotel-bookings/delete-kyc';
    Map<String, String> params = {'bookno': _bookno};
    String content = '{"card-id":"${ref_id}", "card-type":"${ref_type}"}';
    String jsonStr = await ComeInAPI.postQuery(url, content, params);
    print('json->: ${jsonStr}');

    HotelBooking _bookInfo = jsonStr2HotelBooking(jsonStr);
    setState(() {
      bookInfo = _bookInfo;
    });

    return _bookInfo;
  }

  Future<HotelBooking> doDeleteKYCInfo(BuildContext context, String _bookno,
      String _refId, String _refType) async {
    print('ref-id: ${_refId}, ref-type: ${_refType}');
    String url = '/kyc-info/delete-kyc';
    String content =
        '{"book-no":"${_bookno}","ref-id":"${_refId}","ref-type":"${_refType}"}';
    String jsonStr = await ComeInAPI.post(url, content);
    print('json->: ${jsonStr}');
    HotelBooking _bookInfo = jsonStr2HotelBooking(jsonStr);
    setState(() {
      bookInfo = _bookInfo;
    });

    return _bookInfo;
  }

  Future<HotelBooking> doKYCHotelBooking(
      BuildContext context, String _bookno) async {
    print('init by profile');
    UserInfo profile = await ComeInAPI.profile();
    UserConfirm c = UserConfirm.from(profile);
    c.isDelete = false;

    print('book-no: ${_bookno}');
    // if (_bookno == '') {
    String url = '/kyc-hotel-bookings';
    Map<String, String> params = {'bookno': _bookno};
    String jsonStr = await ComeInAPI.postQuery(url, '{}', params);
    print('json->: ${jsonStr}');
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    Map<String, dynamic> json = jsonMap['result'];
    // HotelBooking _book = HotelBooking.fromJson(json);
    // _book.initUserConfirm(c);
    // _book.addUserConfirm(json);
    HotelBooking _book = json2HotelBooking(json);
    return _book;

    //}
  }

  Future<List<UserConfirm>> doListKYCInfo() async {
    UserInfo profile = await ComeInAPI.profile();
    UserConfirm c = UserConfirm.from(profile);
    c.isDelete = false;
    List<UserConfirm> list = [c];

    return list;
  }

  int getStepIndex() {
    return _controller.index;
  }

  @override
  Widget buildBody(BuildContext context) {
    // int i = _controller.index;
    //  print('step-index : ${i}');
    // final params = ModalRoute.of(context)!.settings.arguments as Map;
    //  String bookNO = params['booking_no'];
    //HotelBooking bookInfo = params['booking_info'] as HotelBooking;
    return SizedBox(
      height: 720,
      // child: Expanded(
      // flex: 3,
      // child: Padding(
      //   padding: const EdgeInsets.all(0),
      child: TabContainer(
        controller: _controller,
        color: Colors.lightBlue.shade50,
        tabEdge: TabEdge.top,
        childPadding: const EdgeInsets.all(0.0),
        children: _getChildren3(context),
        tabs: _getTabs3(context),
      ),
      // ),
      // ),
    );
  }

  List<Widget> _getTabs3(BuildContext context) => <Widget>[
        Column(children: [
          SizedBox(
            height: 5,
          ),
          Icon(
            Icons.info_rounded,
          ),
          const Text(
            "Info",
            style: TextStyle(fontSize: 12),
          )
        ]),
        Column(children: [
          SizedBox(
            height: 5,
          ),
          Icon(
            FontAwesomeIcons.key,
          ),
          const Text(
            "keycard",
            style: TextStyle(fontSize: 12),
          )
        ]),
        Column(children: [
          SizedBox(
            height: 5,
          ),
          Icon(
            FontAwesomeIcons.addressCard,
          ),
          const Text(
            "confirm",
            style: TextStyle(fontSize: 12),
          )
        ]),
      ];

  List<Widget> _getChildren3(BuildContext context) => <Widget>[
        HotelBookingDetailCard(
          onHotelBookInit: doHotelBooking,
          onLoad: onLoading,
          bookno: widget.bookno,
          onStepIndex: getStepIndex,
        ),

        HotelKeyCard(
          bookNO: widget.bookno,
          onStepIndex: getStepIndex,
          onLoad: onLoading,
          onHotelBookInit: doHotelBooking,
        ),
        UserConfirmCard(
          //  noHotelConfirm: 2,
          //  active: (info.targetEmail == '') ? true : false,
          bookno: widget.bookno,
          onDeleteKYC: doDeleteKYCInfo,
          //  onAddKYC: doAddKYCInfo,
          onLoad: onLoading,
          onHotelBookingInit: doKYCHotelBooking,
          onConfirmBookingKYC: doConfirmBookingKYCInfo,
          onDeleteBookingKYC: doDeleteBookingKYCInfo,
          // onUserConfirm: doListKYCInfo,
          onStepIndex: getStepIndex,
        ),
        //  ),
        //  ],
        // ),
      ];
  HotelBooking initBookingInfo(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    String bookNO = params['booking_no'];
    HotelBooking book = params['booking_info'] as HotelBooking;
    return book;
  }
}
