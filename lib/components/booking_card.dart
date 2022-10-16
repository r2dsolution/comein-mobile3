import 'package:barcode_widget/barcode_widget.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/comein_image.dart';
import 'package:thecomein/helper/datetime_utils.dart';
import 'package:thecomein/models/hotel_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class BookingCard2 extends StatelessWidget {
  final Function() onShareEvent;
  final String assetImage;
  final HotelProfile hotel;
  final String bookNO;

  const BookingCard2(
      {Key? key,
      required this.onShareEvent,
      required this.assetImage,
      required this.hotel,
      required this.bookNO})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFCard(
      color: Colors.grey.shade50,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      image: Image.asset(
        assetImage,
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      showImage: true,
      title: HotelTitle(hotel: hotel) as GFListTile,
      content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2, // 60% of space => (6/(6 + 4))
              child: Container(
                // color: Colors.red,
                child: Text(
                  bookNO,
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
                child: Row(children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.searchPlus,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.share,
                      size: 20,
                    ),
                    onPressed: onShareEvent,
                  )
                ]),
              ),
            ),
          ]),
    );
  }
}

class HotelTitle extends StatelessWidget {
  final HotelProfile hotel;

  const HotelTitle({Key? key, required this.hotel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GFListTile(
      //color: Colors.li,
      avatar: GFAvatar(
        child: Text(
          hotel.shortName,
          style: TextStyle(color: Colors.white),
        ),
        //  backgroundImage: AssetImage('assets/images/hotel01.jpeg'),
      ),
      titleText: hotel.name,
      subTitleText: hotel.address,
    );
  }
}

class HotelBookingDetailCard extends StatefulWidget {
  final Future<HotelBooking?> Function(BuildContext, String) onHotelBookInit;
  final Function(bool) onLoad;
  final int Function() onStepIndex;
  final String bookno;
  //final int stepIndex;

  const HotelBookingDetailCard(
      {Key? key,
      required this.onHotelBookInit,
      required this.onLoad,
      required this.bookno,
      required this.onStepIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HotelBookingDetailCardState();
  }
}

class HotelBookingDetailCardState extends State<HotelBookingDetailCard> {
  String checkInDate = "-";
  String checkOutDate = "-";
  String bookNO = '-';
  String customerName = '-';
  String hotelName = '-';
  String hotelAddress = '-';
  HotelProfile? _hotel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => onInit(context));
  }

  onInit(BuildContext context) async {
    int stepIndex = widget.onStepIndex();
    print('stepIndex=${stepIndex}');
    if (stepIndex == 0) {
      print('load on booking-card');
      widget.onLoad(true);
      HotelBooking? _book =
          await widget.onHotelBookInit(context, widget.bookno);
      Future.delayed(
          loadingTimes,
          () => {
                setState(() {
                  _hotel = _book!.hotel;
                  bookNO = _book.bookNO;
                  customerName = _book.customer;
                  //customerName = '';
                  hotelName = _book.hotel.name;
                  hotelAddress = _book.hotel.address;
                  checkInDate = _book.checkIn;
                  checkOutDate = _book.checkOut;
                  //DateFormat('yyyy-MM-dd').format(_book.checkInDate!);
                }),
                widget.onLoad(false),
              });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    Color tColor = Colors.white10;
    return GFCard(
      color: Colors.grey.shade50,
      //boxFit: BoxFit.cover,
      //titlePosition: GFPosition.start,
      showImage: true,
      image: ComeInImage.hotelImage(
          _hotel,
          MediaQuery.of(context).size.height * 0.2,
          MediaQuery.of(context).size.width),
      content: Column(children: [
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("เลขที่การจอง"),
          trailing: Text(bookNO),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("ผู้จอง"),
          trailing: Text(customerName),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("โรงแรม"),
          trailing: Text(hotelName),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("ที่อยู่"),
          trailing: Text(hotelAddress),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("วันที่เข้าพัก"),
          trailing: Text(checkInDate),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("วันที่ออก"),
          trailing: Text(checkOutDate),
        ),
        SizedBox(
          height: 10,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(
                errorCorrectLevel: BarcodeQRCorrectionLevel.high,
              ),
              data: 'https://pub.dev/packages/barcode_widget',
              width: 120,
              height: 120,
            ),
            // Container(
            //   color: Colors.white,
            //   width: 60,
            //   height: 60,
            //   child: const FlutterLogo(),
            // ),
          ],
        )
      ]),
    );
  }
}

class HotelBookingShortCard extends StatefulWidget {
  final Future<HotelBooking> Function(BuildContext, String) onHotelBookInit;
  final Function(bool) onLoad;
  final String bookno;

  const HotelBookingShortCard(
      {Key? key,
      required this.onHotelBookInit,
      required this.onLoad,
      required this.bookno})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HotelBookingShortCardState(bookno);
  }
}

class HotelBookingShortCardState extends State<HotelBookingShortCard> {
  String checkInDate = "-";
  final String bookNO;
  String customerName = '-';
  String hotelName = '-';
  String hotelAddress = '-';

  HotelBookingShortCardState(this.bookNO);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => onInit(context));
  }

  onInit(BuildContext context) async {
    widget.onLoad(true);
    HotelBooking _book = await widget.onHotelBookInit(context, widget.bookno);
    Future.delayed(
        loadingTimes,
        () => {
              setState(() {
                // customerName = _book.customer;
                customerName = _book.customer;
                hotelName = _book.hotel.name;
                hotelAddress = _book.hotel.address;
                checkInDate = checkInDate =
                    DateFormat('yyyy-MM-dd').format(_book.checkInDate!);
              }),
              widget.onLoad(false),
            });
  }

  @override
  Widget build(BuildContext context) {
    Color tColor = Colors.white10;
    return GFCard(
      color: Colors.grey.shade50,
      content: Column(children: [
        // ListTile(
        //   dense: true,
        //   tileColor: tColor,
        //   leading: Text("เลขที่การจอง"),
        //   trailing: Text(bookNO),
        // ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("ผู้จอง"),
          trailing: Text(customerName),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("โรงแรม"),
          trailing: Text(hotelName),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("ที่อยู่"),
          trailing: Text(hotelAddress),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("วันที่เข้าพัก"),
          trailing: Text(checkInDate),
        ),
      ]),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Function() onShareEvent;
  final Function() onDetailEvent;
  final Function() onCancelEvent;
  final HotelProfile? hotel;
  final TourProfile? tour;
  final String bookno;
  final DateTime? bookDate;
  final DateTime? checkOutDate;
  final String target;

  const BookingCard(
      {Key? key,
      required this.bookno,
      required this.bookDate,
      this.checkOutDate,
      this.hotel,
      this.tour,
      required this.target,
      required this.onDetailEvent,
      required this.onShareEvent,
      required this.onCancelEvent})
      : super(key: key);

  List<Widget> buildAction(String target) {
    return [
      FlatButton(
        padding: EdgeInsets.zero,
        // color: Colors.red,
        minWidth: 25,
        child: Column(children: [
          FaIcon(
            FontAwesomeIcons.infoCircle,
            color: Colors.blue,
            size: 16,
          ),
          Text("info"),
        ]),
        // onPressed: () {
        //   Navigator.pushNamed(
        //       context, DetailHotelBookingScreen.routeName,
        //       arguments: {
        //         "booking_no": "CI8398",
        //         // "add_confirm": ""
        //       });
        // },
        onPressed: onDetailEvent,
      ),
      FlatButton(
        padding: EdgeInsets.zero,
        // color: Colors.red,
        minWidth: 25,
        child: Column(children: [
          FaIcon(
            FontAwesomeIcons.shareAltSquare,
            color: (target == '') ? Colors.blue : Colors.grey,
            size: 16,
          ),
          Text("share"),
        ]),
        //onPressed: () {
        // Navigator.pushNamed(
        //     context, Hotel1BookingScreen.routeName,
        //     arguments: {"booking_no": "CI8398"});
        //},
        onPressed: (target == '') ? onShareEvent : null,
      ),
    ];
  }

  String toBookDate() {
    print('toBookDate -> ${bookDate}');
    return ComeInDateUtils.toStrFormat(bookDate, 'dd/MMM/yyyy');
  }

  @override
  Widget build(BuildContext context) {
    return GFCard(
      color: Colors.grey.shade50,
      boxFit: BoxFit.cover,
      titlePosition: GFPosition.start,
      // image: Image.asset(
      //   (hotel != null)
      //       ? hotel!.assetImages
      //       : (tour != null)
      //           ? tour!.assetImages
      //           : 'assets/images/noimage.jpeg',
      //   height: MediaQuery.of(context).size.height * 0.2,
      //   width: MediaQuery.of(context).size.width * 0.7,
      //   fit: BoxFit.cover,
      // ),
      // image: HotelImage(hotel!, MediaQuery.of(context).size.height * 0.2,
      //     MediaQuery.of(context).size.width * 0.7),
      // showImage: false,
      title: GFListTile(
        icon: Icon(
          (hotel != null)
              ? FontAwesomeIcons.bed
              : (tour != null)
                  ? FontAwesomeIcons.suitcaseRolling
                  : FontAwesomeIcons.image,
          color: Colors.blueAccent,
        ),
        //color: Colors.li,
        avatar: GFAvatar(
          child: Text(
            (hotel != null)
                ? hotel!.shortName
                : (tour != null)
                    ? tour!.shortName
                    : '-',
            style: TextStyle(color: Colors.white),
          ),
          //  backgroundImage: AssetImage('assets/images/hotel01.jpeg'),
        ),
        titleText: (hotel != null)
            ? hotel!.name
            : (tour != null)
                ? tour!.name
                : '-',
        subTitleText: (hotel != null)
            ? hotel!.province + ',' + hotel!.country
            : (tour != null)
                ? tour!.address
                : '-',
      ),
      content: Column(children: [
        GestureDetector(
          onTap: onDetailEvent, // Image tapped
          child: (hotel != null)
              ? HotelImage(
                  hotel: hotel!,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.7)
              : TourImage(
                  tour: tour,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.7),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 6, // 60% of space => (6/(6 + 4))
                child: Container(
                  // color: Colors.red,
                  child: Text(
                    // (hotel != null)
                    //     ? "Hotel Booking\n" + bookno
                    //     : (tour != null)
                    //         ? "Tour Booking\n" + bookno
                    //         : '-',
                    // DateFormat('dd/MM/yyyy').format(bookDate) + "\n" + bookno,
                    toBookDate() + "\n" + bookno,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 4, // 60% of space => (6/(6 + 4))
                child: Container(
                  // color: Colors.red,
                  alignment: Alignment.centerRight,
                  //color: Colors.red,
                  child: Row(children: buildAction(target)
                      // [
                      //   FlatButton(
                      //     padding: EdgeInsets.zero,
                      //     // color: Colors.red,
                      //     minWidth: 30,
                      //     child: Column(children:
                      //     [
                      //       FaIcon(
                      //         FontAwesomeIcons.infoCircle,
                      //         color: Colors.blue,
                      //         size: 20,
                      //       ),
                      //       Text("info"),
                      //     ]),
                      //     // onPressed: () {
                      //     //   Navigator.pushNamed(
                      //     //       context, DetailHotelBookingScreen.routeName,
                      //     //       arguments: {
                      //     //         "booking_no": "CI8398",
                      //     //         // "add_confirm": ""
                      //     //       });
                      //     // },
                      //     onPressed: onDetailEvent,
                      //   ),
                      //   FlatButton(
                      //     padding: EdgeInsets.zero,
                      //     // color: Colors.red,
                      //     minWidth: 30,
                      //     child: Column(children: [
                      //       FaIcon(
                      //         FontAwesomeIcons.shareAltSquare,
                      //         color: Colors.blue,
                      //         size: 20,
                      //       ),
                      //       Text("share"),
                      //     ]),
                      //     //onPressed: () {
                      //     // Navigator.pushNamed(
                      //     //     context, Hotel1BookingScreen.routeName,
                      //     //     arguments: {"booking_no": "CI8398"});
                      //     //},
                      //     onPressed: onShareEvent,
                      //   ),
                      // ]
                      ),
                ),
              ),
            ]),
        (target != '')
            // ? GFButton(
            //     onPressed: () {},
            //     text: "primary",
            //     icon: Icon(Icons.share),
            //   )
            // ? TextButton.icon(
            //     onPressed: () {},
            //     icon: Icon(
            //       FontAwesomeIcons.envelope,
            //       size: 18,
            //     ),
            //     label: Text(" ${target}"))
            ? Container(
                // color: Colors.red,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   FontAwesomeIcons.envelope,
                    //   size: 18,
                    // ),
                    //  TextButton(child: ,)
                    TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          ConfirmAlert(
                              context: context,
                              message: 'Do you cancel forward email ?',
                              onOK: onCancelEvent);
                        },
                        icon: Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text("${target}",
                            style: TextStyle(color: Colors.white))),
                  ],
                ))
            : Container(),
      ]),
      // buttonBar: GFButtonBar(
      //   alignment: WrapAlignment.end,
      //   children: <Widget>[
      //     GFAvatar(
      //       backgroundColor: GFColors.PRIMARY,
      //       child: Icon(
      //         Icons.share,
      //         color: Colors.white,
      //       ),
      //     ),
      //     GFAvatar(
      //       backgroundColor: GFColors.SECONDARY,
      //       child: Icon(
      //         Icons.search,
      //         color: Colors.white,
      //       ),
      //     ),
      //     GFAvatar(
      //       backgroundColor: GFColors.SUCCESS,
      //       child: Icon(
      //         Icons.phone,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class TourBookingDetailCard extends StatefulWidget {
  final TourBooking Function(BuildContext) onInit;
  final Function(bool) onLoad;

  const TourBookingDetailCard(
      {Key? key, required this.onInit, required this.onLoad})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TourBookingDetailCardState();
  }
}

class TourBookingDetailCardState extends State<TourBookingDetailCard> {
  @override
  Widget build(BuildContext context) {
    Color tColor = Colors.white10;
    return GFCard(
      color: Colors.grey.shade50,
      //boxFit: BoxFit.cover,
      //titlePosition: GFPosition.start,
      showImage: true,
      image: Image.asset(
        'assets/images/hotel01.jpeg',
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      content: Column(children: [
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("เลขที่การจอง"),
          trailing: Text('xxx'),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("ผู้จอง"),
          trailing: Text('customerName'),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("โรงแรม"),
          trailing: Text('hotelName'),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("ที่อยู่"),
          trailing: Text('hotelAddress'),
        ),
        ListTile(
          dense: true,
          tileColor: tColor,
          leading: Text("วันที่เข้าพัก"),
          trailing: Text('checkInDate'),
        ),
        SizedBox(
          height: 10,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(
                errorCorrectLevel: BarcodeQRCorrectionLevel.high,
              ),
              data: 'https://pub.dev/packages/barcode_widget',
              width: 120,
              height: 120,
            ),
            // Container(
            //   color: Colors.white,
            //   width: 60,
            //   height: 60,
            //   child: const FlutterLogo(),
            // ),
          ],
        )
      ]),
    );
  }
}
