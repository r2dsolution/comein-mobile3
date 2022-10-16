import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/models/hotel_profile.dart';
import 'package:thecomein/models/user_confirm.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thecomein/routes.dart';

class UserConfirmCard extends StatefulWidget {
  // final int noHotelConfirm;
  // final bool active;
  //final HotelBooking bookInfo;
  final String bookno;
  // final Function() onUserConfirm;
  final Function(BuildContext, String) onHotelBookingInit;
  final Function(BuildContext, String, String, String) onDeleteKYC;
  //final Function(BuildContext, UserConfirm) onAddKYC;
  final Function(BuildContext, String, String, String) onConfirmBookingKYC;
  final Future<HotelBooking> Function(BuildContext, String, String, String)
      onDeleteBookingKYC;
  final Function(bool) onLoad;
  //final bool Function(String) onBookingKYC;
  final int Function() onStepIndex;

  const UserConfirmCard(
      {Key? key,
      // required this.noHotelConfirm,
      //  required this.active,
      required this.onHotelBookingInit,
      required this.onDeleteKYC,
      //   required this.onAddKYC,
      required this.onLoad,
      required this.onConfirmBookingKYC,
      required this.onDeleteBookingKYC,
      // required this.onBookingKYC,
      required this.onStepIndex,
      required this.bookno})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserConfirmCard();
  }
}

class _UserConfirmCard extends State<UserConfirmCard> {
  int noUserConfirm = 0;
  //List<UserConfirm> confirms = [];
  HotelBooking bookInfo = HotelBooking();
  //bool active = false; //: (info.targetEmail == '') ? true : false
  // int maxConfirm = 0; //widget.noHotelConfirm;
  late UserConfirm userOwner;
  List<UserConfirm> confirms = [];
  TextEditingController refNameController = new TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => doInitScreen(context));
  }

  doInitScreen(BuildContext c) async {
    int stepIndex = widget.onStepIndex();
    if (stepIndex == 2) {
      widget.onLoad(true);
      // UserInfo profile = await ComeInAPI.profile();
      // UserConfirm c = UserConfirm.from(profile);
      //  c.isDelete = false;

      HotelBooking _book = await widget.onHotelBookingInit(c, widget.bookno);
      // confirms.addAll(list);

      //  HotelBooking _book = await widget.onHotelBookingInit(c, widget.bookno);

      _updateBookInfo(_book);

      // final params = ModalRoute.of(context)!.settings.arguments as Map;
      // Future.delayed(
      //     loadingTimes,
      //     () async => {
      //           setState(() {
      //             //confirms.add(c);
      //             if (params.containsKey('confirm_info')) {
      //               // String aName = params['add_confirm'] as String;
      //               // UserConfirm a = UserConfirm(aName);
      //               UserConfirm a = params['confirm_info'] as UserConfirm;

      //               print('name=' + a.name);
      //               bool isNewElement = confirms
      //                   .where((element) => element.name == a.name)
      //                   .isEmpty;

      //               print('is-new user: ${isNewElement}');
      //               if (isNewElement) {
      //                 confirms.add(a);
      //               } else {
      //                 confirms
      //                     .where((element) => element.name == a.name)
      //                     .first
      //                     .isValid = true;
      //               }
      //             }
      //           })
      //         });
      widget.onLoad(false);
    }
  }

  bool isConfirm(UserConfirm user) {
    String refId = user.cardId;
    print('confirm ref-id: ${refId}');
    bool _isConfirm = bookInfo.kycCardId.contains(refId);

    return _isConfirm;
  }

  _updateBookInfo(HotelBooking _bookInfo) {
    setState(() {
      bookInfo = _bookInfo;
      confirms = _bookInfo.userConfirm;
      noUserConfirm = _bookInfo.kycCardId.length;
    });
  }

  doDeleteKYC(String _bookno, String _refId, String _refType) async {
    widget.onLoad(true);
    HotelBooking _bookInfo =
        await widget.onDeleteKYC(context, _bookno, _refId, _refType);
    // HotelBooking _book =
    //     await widget.onHotelBookingInit(context, widget.bookno);
    _updateBookInfo(_bookInfo);

    widget.onLoad(false);
  }

  doConfirmKYC(String _refId, String _refType) async {
    widget.onLoad(true);
    await widget.onConfirmBookingKYC(context, widget.bookno, _refId, _refType);
    HotelBooking _bookInfo =
        await widget.onHotelBookingInit(context, widget.bookno);

    _updateBookInfo(_bookInfo);
    widget.onLoad(false);
  }

  doUnSelectBookingKYC(UserConfirm _confirm) async {
    print('onOK-doUnSelectBookingKYC');

    widget.onLoad(true);
    HotelBooking _bookInfo = await widget.onDeleteBookingKYC(
        context, widget.bookno, _confirm.cardId, _confirm.cardType);
    _updateBookInfo(_bookInfo);
    widget.onLoad(false);
  }

  doSelectBookingKYC(UserConfirm _confirm) async {
    print('onOK-doSelectBookingKYC');

    widget.onLoad(true);
    HotelBooking _bookInfo = await widget.onConfirmBookingKYC(
        context, widget.bookno, _confirm.cardId, _confirm.cardType);
    _updateBookInfo(_bookInfo);
    widget.onLoad(false);
  }

  @override
  Widget build(BuildContext context) {
    bool active = (bookInfo.targetEmail == '') ? true : false;
    int maxConfirm = bookInfo.visitorAdult + bookInfo.visitorChild;
    return (!active)
        ? Center(
            child: Text(
            "No Information.",
            style: TextStyle(fontSize: 25),
          ))
        : Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                // Row(
                //     IconButton(
                //         onPressed: () {}, icon: Icon(FontAwesomeIcons.userPlus))
                //   ],
                // ),
                // Text(' Confirmation',
                //     style: Theme.of(context).textTheme.headline5),
                Text(
                    'You are selected ${noUserConfirm}/${maxConfirm} person(s) to confirm booking.',
                    style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 20,
                ),
                // Text(' Settings', style: Theme.of(context).textTheme.headline5),
                // const Spacer(flex: 1),
                // Expanded(
                //   flex: 3,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [

                for (var user in confirms)
                  //CheckboxListTile(
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      color: Colors.white,
                      child: CheckboxListTile(
                        tileColor: Colors.red,
                        // controlAffinity: ListTileControlAffinity.leading,
                        // dense: true,
                        // title: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(user.name, style: TextStyle(fontSize: 20)),
                        //     ]),
                        // title: Row(children: [
                        //   Text(user.name, style: TextStyle(fontSize: 18)),
                        //   Icon(Icons.edit, size: 18)
                        // ]),
                        //subtitle: Text("edit | delete"),
                        title: GestureDetector(
                            onTap: () {
                              print('click on username');
                            },
                            child: Text(user.displayName,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        subtitle: Row(children: [
                          // ElevatedButton(
                          //   onPressed: () {},
                          //   child: Text("edit"),
                          // ),
                          // edit button
                          // (user.isEdit && !isConfirm(user))
                          //     ? TextButton.icon(
                          //         onPressed: () {
                          //           Navigator.pushNamed(context,
                          //               ROUTE_NAME_CONFIRM_HOTEL_BOOKING,
                          //               arguments: {
                          //                 "booking_no": widget.bookno,
                          //                 "user_confirm": user
                          //               });
                          //         },
                          //         icon: Icon(FontAwesomeIcons.edit, size: 15),
                          //         label: Text("edit"))
                          //     : Text(""),
                          // delete button
                          (user.isDelete && !isConfirm(user))
                              ? TextButton.icon(
                                  onPressed: () {
                                    ConfirmAlert(
                                        context: context,
                                        message: "confirm to delete ?",
                                        onOK: () async {
                                          Navigator.pop(context);
                                          await doDeleteKYC(widget.bookno,
                                              user.cardId, user.cardType);
                                        });
                                  },
                                  icon:
                                      Icon(FontAwesomeIcons.trashAlt, size: 15),
                                  label: Text("delete "))
                              : Text(""),
                          // end delete button
                          //label: Text("edit"))
                        ]),
                        value: isConfirm(user),
                        onChanged: (v) {
                          if (!user.isValid) {
                            ConfirmAlert(
                                context: context,
                                message: 'Invalid Information.',
                                onOK: () async => {
                                      Navigator.pushNamed(context,
                                          ROUTE_NAME_CONFIRM_HOTEL_BOOKING,
                                          arguments: {
                                            "booking_no": widget.bookno,
                                            "confirm_info": user
                                          }),
                                    });
                          } else if (v!) {
                            ConfirmAlert(
                              context: context,
                              message: 'Are you Confirm to select',
                              onOK: () async => {
                                print('onOK'),
                                Navigator.pop(context),
                                await doSelectBookingKYC(user),
                              },
                            );
                          } else {
                            ConfirmAlert(
                              context: context,
                              message: 'Are you Confirm to unselected',
                              onOK: () async => {
                                Navigator.pop(context),
                                await doUnSelectBookingKYC(user),
                              },
                            );
                          }
                        },
                        secondary: SizedBox(
                          height: 60,
                          width: 60,
                          // child: IconButton(
                          //   icon: Icon(Icons.ac_unit),
                          //   onPressed: () {
                          //     print('click icon');
                          //   },
                          // ),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/Profile.png"),
                          ),
                          // child: PopupMenuButton(
                          //   // child: CircleAvatar(
                          //   //   backgroundImage: AssetImage("assets/images/Profile.png"),
                          //   // ),
                          //   child: Icon(FontAwesomeIcons.userEdit),
                          //   itemBuilder: (context) => [
                          //     PopupMenuItem(
                          //       child: ListTile(
                          //         title: Text("Edit", style: TextStyle(fontSize: 15)),
                          //         trailing: Icon(Icons.account_box),
                          //         // onTap: () =>
                          //         //     Navigator.pushNamed(context, ProfileScreen.routeName),
                          //       ),
                          //       value: 1,
                          //     ),
                          //   ],
                          // ),
                        ),
                      ),
                    ),
                  ),

                // SwitchListTile(
                //   title: const Text('Analytics'),
                //   value: false,
                //   onChanged: (v) {},
                //   secondary: SizedBox(
                //     height: 40,
                //     width: 40,
                //     child: CircleAvatar(
                //       backgroundImage: AssetImage("assets/images/Profile.png"),
                //       // backgroundImage: MemoryImage(profileData),
                //       // backgroundImage: img,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                DefaultButton(
                    text: 'Add Person to Confirm Booking',
                    press: () {
                      InputAlert(
                          context: context,
                          inputController: refNameController,
                          onSubmit: () =>
                              {doAddRefName(refNameController.text.trim())});

                      // Navigator.pushNamed(
                      //     context, ROUTE_NAME_CONFIRM_HOTEL_BOOKING,
                      //     arguments: {"booking_no": widget.bookno});
                    }),
              ],
            ),
          );
  }

  doAddRefName(String _refname) {
    if (!_refname.isEmpty) {
      print('push-submit to ref-name: ${refNameController.text}');
      Navigator.pop(context);
      Navigator.pushNamed(context, ROUTE_NAME_ADD_KYC_BOOKING,
          arguments: {"booking_no": widget.bookno, "ref-name": "${_refname}"});
    }
  }
}
