import 'package:thecomein/components/comein_image.dart';
import 'package:thecomein/models/hotel_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

class HotelKeyCard extends StatefulWidget {
  final String bookNO;
  // final int stepIndex;
  final Future<HotelBooking?> Function(BuildContext, String) onHotelBookInit;
  final Function(bool) onLoad;
  final int Function() onStepIndex;

  const HotelKeyCard(
      {Key? key,
      required this.bookNO,
      required this.onStepIndex,
      required this.onHotelBookInit,
      required this.onLoad})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HotelKeyCardState();
  }
}

class HotelKeyCardState extends State<HotelKeyCard> {
  String keycard = '-';
  String roomName = '-';
  String roomDesc = '-';
  int adult = 0;
  int child = 0;
  HotelProfile? _hotel;

  // const HotelKeyCardState({Key? key, this.keycard = ''}) : super(key: key);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => onInit(context));
  }

  onInit(BuildContext context) async {
    int stepIndex = widget.onStepIndex();
    print('onInit -> stepIndex=${stepIndex}');
    if (stepIndex == 1) {
      print('load on keycard');
      widget.onLoad(true);
      HotelBooking? _book =
          await widget.onHotelBookInit(context, widget.bookNO);
      print(_book);
      setState(() {
        _hotel = _book?.hotel;
        roomName = _book!.roomName;
        roomDesc = _book.roomDesc;
        adult = _book.visitorAdult;
        child = _book.visitorChild;
      });
      widget.onLoad(false);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     SizedBox(
    //       height: 20,
    //     ),
    //     Center(
    //       child:
    //           Text('No Keycard', style: Theme.of(context).textTheme.headline5),
    //     ),
    //     const Spacer(),
    //   ],
    // );
    Color tColor = Colors.white10;
    double titleSize = 18;
    // return GFCard(
    //   color: Colors.grey.shade50,
    //   //boxFit: BoxFit.cover,
    //   //titlePosition: GFPosition.start,
    //   showImage: true,
    //   image: Image.asset(
    //     'assets/images/noimage.jpeg',
    //     height: MediaQuery.of(context).size.height * 0.2,
    //     width: MediaQuery.of(context).size.width,
    //     fit: BoxFit.cover,
    //   ),
    //   content:
    return Column(children: [
      GFCard(
        color: Colors.grey.shade50,
        //boxFit: BoxFit.cover,
        //titlePosition: GFPosition.start,
        showImage: true,
        // image: Image.asset(
        //   'assets/images/noimage.jpeg',
        //   height: MediaQuery.of(context).size.height * 0.2,
        //   width: MediaQuery.of(context).size.width,
        //   fit: BoxFit.cover,
        // ),
        image: ComeInImage.noImage(MediaQuery.of(context).size.height * 0.2,
            MediaQuery.of(context).size.width),
      ),
      Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              // Center(
              //   child: Text('NO Keycard',
              //       style: Theme.of(context).textTheme.headline5),
              // ),
              ListTile(
                dense: true,
                tileColor: tColor,
                leading: Icon(FontAwesomeIcons.key),
                title: Text(
                  "Keycard",
                  style: TextStyle(fontSize: titleSize),
                ),
                subtitle: Text((keycard == '') ? '-' : keycard),
              ),
              ListTile(
                dense: true,
                tileColor: tColor,
                leading: Icon(FontAwesomeIcons.bed),
                title: Text("Room", style: TextStyle(fontSize: titleSize)),
                subtitle: Text(roomName),
              ),
              ListTile(
                dense: true,
                tileColor: tColor,
                leading: Icon(FontAwesomeIcons.userFriends),
                title: Text("Visitor", style: TextStyle(fontSize: titleSize)),
                subtitle: Text('${adult} Adults, ${child} child'),
              ),
              ListTile(
                dense: true,
                tileColor: tColor,
                title:
                    Text("Description", style: TextStyle(fontSize: titleSize)),
                subtitle: Text(roomDesc),
              ),
            ],
          )),
    ]);

    // content: Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     SizedBox(
    //       height: 20,
    //     ),
    //     Center(
    //       child: Text('No Keycard',
    //           style: Theme.of(context).textTheme.headline5),
    //     ),
    //     const Spacer(),
    //   ],
    // ),
    // );
  }
}
