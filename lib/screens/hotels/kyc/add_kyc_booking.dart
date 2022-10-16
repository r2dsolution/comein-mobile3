import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/email_personal_content.dart';
import 'package:thecomein/components/id_card_content.dart';
import 'package:thecomein/components/signature_content.dart';
import 'package:thecomein/helper/comein_api.dart';
import 'package:thecomein/helper/s3_api.dart';
import 'package:thecomein/models/user_confirm.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/size_config.dart';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
//import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:enhance_stepper/enhance_stepper.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

class AddKYCBookingScreen extends StatelessWidget {
  static String routeName = ROUTE_NAME_ADD_KYC_BOOKING;

  const AddKYCBookingScreen({Key? key}) : super(key: key);
  UserConfirm initUserConfirm() {
    return UserConfirm('', 'NATIONAL_CARD', 'EN');
  }

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    String _bookno = params['booking_no'];
    String _refname = params['ref-name'];
    //String? _refId = params['ref-id'];
    UserConfirm? p_confirm = params['user_confirm'];
    if (p_confirm != null) {
      print('user-confirm.refId=${p_confirm.cardId}');
    } else {
      print('use default user-confirm');
    }

    UserConfirm default_confirm = initUserConfirm();

    return AddKYCBookingNavScreen(
      titleText: 'Confirm Booking.',
      bookno: _bookno,
      refname: _refname,
      user_confirm: p_confirm == null ? default_confirm : p_confirm,
      stepIndex: 0,
    );
  }
}

class AddKYCBookingNavScreen extends DefaultNavigatorScreen {
  final String titleText;
  final String bookno;
  final String refname;

  UserConfirm user_confirm;
  int stepIndex = 0;
  AddKYCBookingNavScreen(
      {Key? key,
      required this.titleText,
      required this.bookno,
      required this.refname,
      required this.user_confirm,
      required this.stepIndex})
      : super(key: key, title: titleText);

  @override
  State<StatefulWidget> createState() {
    return _AddKYCBookingNavScreen(stepIndex);
  }
}

enum ConfirmStepState { PersonalInfo }

class _AddKYCBookingNavScreen
    extends DefaultNavigatorScreenState<AddKYCBookingNavScreen> {
  int currentStep = 0;
  StepperType _type = StepperType.horizontal;
  List<Tuple2> tuples = [
    Tuple2(
      FontAwesomeIcons.userCheck,
      ConfirmStepState.PersonalInfo,
    ),
    Tuple2(
      Icons.directions_bus,
      StepState.editing,
    ),
    Tuple2(
      Icons.directions_railway,
      StepState.complete,
    ),
    // Tuple2(Icons.directions_boat, StepState.disabled, ),
    // Tuple2(Icons.directions_car, StepState.error, ),
  ];
  int _index;
  bool isIDCard = false;
  bool isUserInfo = false;
  String confirmName = '';
  UserConfirm? _personInfo;
  UserConfirm? _scanInfo;

  _AddKYCBookingNavScreen(this._index);

  @override
  Widget buildBody(BuildContext context) {
    SizeConfig().init(context);
    final params = ModalRoute.of(context)!.settings.arguments as Map;

    // final params = ModalRoute.of(context)!.settings.arguments as Map;
    // HotelBooking bookInfo = params['booking_info'] as HotelBooking;

    // final SignatureController _controller = SignatureController(
    //   penStrokeWidth: 5,
    //   penColor: Colors.black,
    //   exportBackgroundColor: Colors.white,
    // );
    // var _signatureCanvas = Signature(
    //   controller: _controller,
    //   width: SizeConfig.screenWidth - 100,
    //   height: 180,
    //   backgroundColor: Colors.grey,
    // );

    // int groupValue = 0;

    // StepperType _type = StepperType.vertical;

    return Column(children: [
      SizedBox(
        height: SizeConfig.screenHeight - 70,
        child: buildStepperCustom(context),
      ),
    ]);
  }

  void go(int index) {
    if (index == -1 && _index <= 0) {
      // ddlog("it's first Step!");
      return;
    }

    if (index == 1 && _index >= tuples.length - 1) {
      //("it's last Step!");
      return;
    }
    if (_index == 1) {}

    setState(() {
      _index += index;
    });
  }

  Color isColor(int i, Color active, Color unActive) {
    return (_index == i) ? active : unActive;
  }

  doScanUserConfirm(UserConfirm p_confirm) async {
    setState(() {
      _scanInfo = p_confirm;
      print("name:" + _scanInfo!.firstname);
    });
  }

  doKYCInfo(UserConfirm p_confirm) async {
    setState(() {
      _personInfo = p_confirm;
      isUserInfo = true;
    });
  }

  doAddKYCInfo() async {
    onLoading(true);
    print('add kyc-info');
    String url = '/kyc-info/add-kyc';
    String content = _personInfo!.toJson();
    print('content->: ${content}');
    String jsonStr = await ComeInAPI.post(url, content);
    print('json->: ${jsonStr}');
    onLoading(false);
  }

  Widget buildStepperCustom(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    String? idcardFilePath = params['idcard'];
    print('idcard FilePath-param: ${idcardFilePath}');
    //HotelBooking bookInfo = params['booking_info'] as HotelBooking;
    final SignatureController _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    var _signatureCanvas = Signature(
      controller: _controller,
      width: SizeConfig.screenWidth - 100,
      height: 180,
      backgroundColor: Colors.grey,
    );
    Future<void> onStepFinish() async {
      print('finished - add kyc-info');

      await doAddKYCInfo();
      //u.isValid = true;
      Navigator.pushReplacementNamed(context, ROUTE_NAME_DETAIL_HOTEL_BOOKING,
          arguments: {
            "booking_no": widget.bookno,
            "tabIndex": 2,
          });
    }

    return EnhanceStepper(
        stepIconSize: 40,
        type: _type,
        horizontalTitlePosition: HorizontalTitlePosition.bottom,
        horizontalLinePosition: HorizontalLinePosition.top,
        currentStep: _index,
        physics: ClampingScrollPhysics(),
        // steps: tuples
        //     .map((e) => EnhanceStep(
        //           icon: Icon(
        //             e.item1,
        //             // Icons.add,
        //             color: Colors.blue,
        //             size: 60,
        //           ),
        //           state: StepState.values[tuples.indexOf(e)],
        //           isActive: _index == tuples.indexOf(e),
        //           title: Text("step ${tuples.indexOf(e)}"),
        //           subtitle: Text(
        //             "${e.item2.toString().split(".").last}",
        //           ),
        //           content: _buildStepContent(context, e, _index),
        //         ))
        //     .toList(),
        steps: [
          EnhanceStep(
              icon: Icon(
                FontAwesomeIcons.idCard,
                color: _index >= 0 ? Colors.blue : Colors.grey,
                size: 40,
              ),
              isActive: _index == 1,
              title: Text(
                "ID Card.",
                style: TextStyle(
                  color: _index >= 0 ? Colors.red : Colors.grey,
                ),
              ),
              //subtitle: Text("upload บัตรประชาชน"),
              content: IDCardPic(
                bookno: widget.bookno,
                refname: widget.refname,
                user_confirm: widget.user_confirm,
                idcardFilename: idcardFilePath,
                onScanUserConfirm: doScanUserConfirm,
                onLoad: onLoading,
                onConfirm: (_value) {
                  print('set id-card value:$_value');
                  setState(() {
                    isIDCard = _value;
                  });
                },
              )),
          // content: IDCardOverLay(),
          //  ),
          EnhanceStep(
              icon: Icon(
                FontAwesomeIcons.user,
                color: _index >= 1 ? Colors.blue : Colors.grey,
                size: 40,
              ),
              isActive: _index == 0,
              title: Text(
                "User Info.",
                style: TextStyle(
                  color: _index >= 1 ? Colors.red : Colors.grey,
                ),
              ),
              //  subtitle: Text("ระบุข้อมุลส่วนบุคคล"),
              content: EmailPersonalContent(
                displayName: widget.refname,
                onLoadConfirm: () {
                  return _scanInfo;
                },
                onChangeConfirm: doKYCInfo,
                // onConfirm: (_name) {
                //   setState(() {
                //     isUserInfo = true;
                //     confirmName = _name;
                //   });
                // },
              )),
          EnhanceStep(
            title: Text(
              "Signature",
              style: TextStyle(
                color: _index >= 2 ? Colors.red : Colors.grey,
              ),
            ),
            icon: Icon(
              FontAwesomeIcons.signature,
              color: _index >= 2 ? Colors.blue : Colors.grey,
              size: 40,
            ),
            content: SignaturePic(
              onSignConfirm: (_signData) async {
                String _signImage = await S3API.doUploadS3(_signData);
                setState(() {
                  _personInfo!.signImage = _signImage;
                });
                //await doAddKYCInfo();
              },
            ), //_signatureCanvas
          ),
        ],
        onStepCancel: () {
          go(-1);
        },
        onStepContinue: () {
          go(1);
        },
        onStepTapped: (index) {
          // ddlog(index);
          setState(() {
            _index = index;
          });
        },
        // controlsBuilder: buildStepper,
        controlsBuilder: (BuildContext context, ControlsDetails ctrl) {
          return Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _index == 0 ? null : ctrl.onStepCancel,
                  child: const Text("Back"),
                ),
                const SizedBox(
                  height: 30,
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: _index == 0
                      ? (isIDCard ? ctrl.onStepContinue : null)
                      : (_index == 1
                          ? (isUserInfo ? ctrl.onStepContinue : null)
                          : onStepFinish),
                  child: const Text("Next"),
                ),
              ],
            ),
          );
        });
  }

  // Widget buildStepper(BuildContext context, ControlsDetails ctrl) {
  //   return Container(
  //     alignment: Alignment.center,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         ElevatedButton(
  //           onPressed: _index == 0 ? null : ctrl.onStepCancel,
  //           child: const Text("Back"),
  //         ),
  //         SizedBox(
  //           height: 30,
  //           width: 8,
  //         ),
  //         ElevatedButton(
  //           onPressed: _index == 0
  //               ? (isIDCard ? ctrl.onStepCancel : null)
  //               : (_index == 1
  //                   ? (isUserInfo ? ctrl.onStepContinue : null)
  //                   : ctrl.onStepContinue),
  //           child: const Text("Next"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class ConfirmSteper extends StatelessWidget {
  final Function() onBack;
  final Function() onNext;

  const ConfirmSteper({Key? key, required this.onBack, required this.onNext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            // onPressed: _index == 0 ? null : onBack,
            onPressed: onBack,
            child: Text("Back"),
          ),
          SizedBox(
            height: 30,
            width: 8,
          ),
          ElevatedButton(
            // onPressed: _index == 0
            //     ? (isIDCard ? onBack : null)
            //     : (_index == 1
            //         ? (isUserInfo ? onBack: null)
            //         : onNext),
            onPressed: onNext,
            child: Text("Next"),
          ),
        ],
      ),
    );
  }
}
