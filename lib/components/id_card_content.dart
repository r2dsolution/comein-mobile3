import 'dart:io';

import 'dart:typed_data';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:thecomein/components/card_id_overlay.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/helper/comein_api.dart';
import 'package:thecomein/helper/s3_api.dart';
import 'package:thecomein/routes.dart';
import 'package:thecomein/size_config.dart';
import 'package:thecomein/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:path_provider/path_provider.dart';
import 'package:thecomein/models/user_confirm.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';

// class IDCardContainer extends StatefulWidget {
//   final Function(bool) onConfirm;

//   const IDCardContainer({Key? key, required this.onConfirm}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }

// class _IDCardContainer extends State<IDCardContainer> {
//   bool isUpload = false;
//   String apiToken = '';
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       width: SizeConfig.screenWidth - 100,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 10, 0, 5.0),
//         child: Stack(
//           fit: StackFit.expand,
//           overflow: Overflow.visible,
//           children: [
//             // CircleAvatar(
//             //   backgroundImage: AssetImage("assets/images/idCard.png"),
//             //   // backgroundImage: MemoryImage(profileData),
//             // ),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black),
//                 image: isUpload
//                     ? DecorationImage(
//                         image: AssetImage("assets/images/idCard.jpeg"),
//                         fit: BoxFit.fill)
//                     : null,
//                 color: Colors.grey,
//                 shape: BoxShape.rectangle,
//               ),
//             ),
//             Center(
//               child: SizedBox(
//                 height: 46,
//                 width: 46,
//                 child: isUpload
//                     ? null
//                     : FlatButton(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                           side: BorderSide(color: Colors.white),
//                         ),
//                         color: Color(0xFFF5F6F9),
//                         onPressed: () {
//                           setState(() {
//                             isUpload = true;
//                           });
//                           widget.onConfirm(false);
//                         },
//                         child: SvgPicture.asset("assets/icons/Camera.svg"),
//                       ),
//               ),
//             ),
//             // Positioned(
//             //   right: -23,
//             //   bottom: -23,
//             //   child: SizedBox(
//             //     height: 46,
//             //     width: 46,
//             //     child: FlatButton(
//             //       shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(50),
//             //         side: BorderSide(color: Colors.white),
//             //       ),
//             //       color: Color(0xFFF5F6F9),
//             //       onPressed: () {},
//             //       child: SvgPicture.asset("assets/icons/Camera.svg"),
//             //     ),
//             //   ),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }

class IDCardPic extends StatefulWidget {
  final Function(bool) onConfirm;
  final Function(bool) onLoad;
  final Function(UserConfirm) onScanUserConfirm;
  final String? idcardFilename;
  final String bookno;
  final String refname;
  final UserConfirm user_confirm;

  const IDCardPic(
      {Key? key,
      required this.bookno,
      required this.refname,
      required this.user_confirm,
      required this.idcardFilename,
      required this.onLoad,
      required this.onConfirm,
      required this.onScanUserConfirm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IDCardPic();
  }
}

class _IDCardPic extends State<IDCardPic> {
  bool isUpload = false;
  bool isValid = false;
  String apiToken = '';
  int fieldIndex = 0;
  int validIndex = 0;
  double totalValidIndex = 0;

  CardOverlay overlay = CardOverlay.byFormat(OverlayFormat.cardID1);
  // final _formKey = GlobalKey<FormBuilderState>();
  //const IDCardPic({Key? key, required this.onConfirm}) : super(key: key);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => doInitScreen(context));
  }

  doInitScreen(BuildContext c) async {
    apiToken = await ComeInAPI.initTokenOCR();

    // await ComeInAPI.scanURLIDCard(apiToken,
    //     'https://tawatchai3e231dfcd1b74f2bb33615888fa0fc48213041-dev.s3.us-east-2.amazonaws.com/public/d6c62e40-979b-11ec-8843-6d214f73b438');
  }

  @override
  Widget build(BuildContext context) {
    print('file path:${widget.idcardFilename}');
    print('refId=${widget.user_confirm.cardId}');
    if (widget.idcardFilename != null) {
      setState(() {
        isUpload = true;
      });
    }
    return Column(children: [
      // Container(
      //     alignment: Alignment.centerLeft,
      //     child: Padding(
      //         padding: const EdgeInsets.fromLTRB(20, 0, 0, 10.0),
      //         child: Text("Step 1: Upload ID Card."))),
      ListTile(
        leading: Text("Step 1: Upload ID Card."),
        trailing: Icon(
            isUpload ? FontAwesomeIcons.checkSquare : FontAwesomeIcons.square),
      ),

      // FormBuilder(
      //   key: _formKey,
      //   child: Theme(
      //       data: ThemeData(
      //           inputDecorationTheme:
      //               const InputDecorationTheme(border: InputBorder.none)),
      //       child: FormBuilderImagePicker(
      //         iconColor: Colors.white,
      //         maxWidth: SizeConfig.screenWidth - 100,
      //         maxHeight: 180,
      //         previewWidth: SizeConfig.screenWidth - 120,
      //         previewHeight: 160,
      //         name: 'photos',
      //         imageQuality: 100,
      //         decoration: const InputDecoration(
      //           fillColor: Colors.grey,
      //           filled: true,
      //         ),
      //         maxImages: 1,
      //       )),
      // ),

      // Text(isUpload
      //     ? (isValid ? "status: valid" : "status: not valid")
      //     : "no image."),
      // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //   Text(!isUpload ? "no image" : ""),
      //   GestureDetector(
      //     onTap: () => {
      //       ConfirmAlert(
      //           context: context,
      //           message: "confirm to remove ?",
      //           onOK: () {
      //             setState(() {
      //               isUpload = false;
      //               isValid = false;
      //             });
      //             widget.onConfirm(false);
      //             _formKey.currentState?.reset();
      //             Navigator.pop(context);
      //           })
      //     },
      //     child: Text(
      //       isUpload ? "clear" : "",
      //       style: TextStyle(
      //           decoration: TextDecoration.underline, color: kPrimaryColor),
      //     ),
      //   )
      // ]),
      SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: overlay.ratio!,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.center,
                // image: FileImage(
                //   File(widget.idcardFilename == null
                //       ? ''
                //       : widget.idcardFilename!),
                // ),
                image: widget.idcardFilename == null
                    ? Image.asset('assets/images/noimage.jpeg').image
                    : FileImage(File(widget.idcardFilename!)),
              )),
            ),
          )),
      Container(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: DefaultButton(
            text: 'Take Camera',
            press: () {
              Navigator.pushReplacementNamed(context, ROUTE_NAME_OCR_CARD_ID,
                  arguments: {
                    "booking_no": widget.bookno,
                    "ref-name": widget.refname,
                    "user_confirm": widget.user_confirm,
                  });
            }),
      ),

      // SizedBox(
      //   height: 20,
      // ),
      // ListTile(
      //   leading: Text("Status"),
      //   trailing: Text("no image."),
      // ),
      // Container(
      //     alignment: Alignment.centerLeft,
      //     child: Padding(
      //         padding: const EdgeInsets.fromLTRB(20, 0, 0, 0.0),
      //         child: Text("Step 2: Validate ID Card."))),
      ListTile(
        leading: Text("Step 2: Validate ID Card."),
        trailing: Icon(
            isValid ? FontAwesomeIcons.checkSquare : FontAwesomeIcons.square),
      ),
      DefaultButton(
          text: 'Validate ID Card - ${totalValidIndex.toStringAsFixed(2)}%',
          enable: isUpload,
          press: () async {
            // if (_formKey.currentState!.saveAndValidate()) {
            //   print(_formKey.currentState!.value);

            //   List<dynamic> files = _formKey.currentState!.value['photos'];
            //   print(files[0]);
            //   XFile file = files[0] as XFile;
            //   Uint8List dataList = await file.readAsBytes();
            //   String _key = await S3API.doUploadS3(dataList);
            //   UserConfirm? _confirm =
            //       await ComeInAPI.scanIDCard(apiToken, dataList.toList());
            //   if (_confirm != null) {
            //     doValid(_confirm);
            //     if (validIndex != 0) {
            //       widget.onConfirm(true);
            //     } else {
            //       widget.onConfirm(false);
            //     }

            //     widget.onScanUserConfirm(_confirm);
            //   }
            // }
            String? error = null;
            widget.onLoad(true);
            if (widget.idcardFilename != null) {
              FileImage idcardImage = FileImage(File(widget.idcardFilename!));
              Uint8List dataList = await idcardImage.file.readAsBytes();
              String _key = await S3API.doUploadS3(dataList);

              // String _refId = '';
              // if (widget.user_confirm.cardId != '') {
              //   var r = new Random();
              //   if (r.nextBool()) {
              //     print('reset card-id from scan api');
              //     _refId = widget.user_confirm.cardId;
              //   }
              // }
              UserConfirm? _confirm = await ComeInAPI.scanIDCard(
                  apiToken, widget.user_confirm.cardId, dataList.toList());
              if (_confirm != null) {
                _confirm.refImage = _key;
                error = doValid(_confirm);
                if (validIndex != 0) {
                  widget.onConfirm(true);
                } else {
                  widget.onConfirm(false);
                }

                widget.onScanUserConfirm(_confirm);
              }
            }
            setState(() {
              isValid = true;
            });
            widget.onLoad(false);
            if (error != null) {
              ErrorAlert(context, error);
            }
          }),
      SizedBox(
        height: 40,
      )
    ]);
  }

  doValidField(String _value) {
    if (_value.trim().isNotEmpty) {
      setState(() {
        validIndex = validIndex + 1;
      });
    }
    setState(() {
      fieldIndex = fieldIndex + 1;
      totalValidIndex = validIndex * 100 / fieldIndex;
    });
  }

  String? doValid(UserConfirm _confirm) {
    setState(() {
      validIndex = 0;
      fieldIndex = 0;
      totalValidIndex = 0;
      //validIndex * 100 / fieldIndex;
    });
    print(
        'edit refId=${widget.user_confirm.cardId} to target-refId=${_confirm.cardId}');

    // if (widget.user_confirm.cardId != _confirm.cardId) {
    //   var r = Random();
    //   if (r.nextBool()) {
    //     print('reset confirm.cardId');
    //     _confirm = widget.user_confirm;
    //   }
    // }
    if (widget.user_confirm.cardId == '' ||
        widget.user_confirm.cardId == _confirm.cardId) {
      doValidField(_confirm.namePrefix);
      doValidField(_confirm.namePrefix2);
      doValidField(_confirm.firstname);
      doValidField(_confirm.firstname2);
      doValidField(_confirm.lastname);
      doValidField(_confirm.lastname2);
      doValidField(_confirm.cardId);
      doValidField(_confirm.birthDate);
      doValidField(_confirm.expireDate);
      if (totalValidIndex == 0) {
        return 'Card ID is not valid';
      }
    } else {
      print('not match ref-id');
      return 'Card ID not match';
    }
  }
}
