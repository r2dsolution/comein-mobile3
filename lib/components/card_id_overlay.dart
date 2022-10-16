import 'dart:typed_data';

import 'package:thecomein/helper/comein_api.dart';
import 'package:thecomein/helper/s3_api.dart';
import 'package:thecomein/models/user_confirm.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'dart:io';
import 'package:flutter_camera_overlay/model.dart';
//import 'package:image/image.dart' as img;
import 'package:thecomein/routes.dart';
// import 'package:image_crop/image_crop.dart';

//import 'package:image_cropper/image_cropper.dart';

class CardIDCameraOverlay extends StatefulWidget {
  static const String routeName = ROUTE_NAME_OCR_CARD_ID;

  const CardIDCameraOverlay({Key? key}) : super(key: key);

  // CardIDCameraOverlay({Key? key}) : super(key: key);

  @override
  CardIDCameraOverlayState createState() => CardIDCameraOverlayState();
}

class CardIDCameraOverlayState extends State<CardIDCameraOverlay> {
  OverlayFormat format = OverlayFormat.cardID1;
  int tab = 0;

  doScan(XFile cardIDFile, String refId, CardOverlay overlay) async {
    print(cardIDFile);
    print(cardIDFile.mimeType);
    // CropAspectRatio aspectRatio =
    //     CropAspectRatio(ratioX: overlay.ratio!, ratioY: overlay.ratio!);
    // String path = cardIDFile.path;
    // File? croppedFile = await ImageCropper().cropImage(
    //   sourcePath: path,
    //   // aspectRatio: aspectRatio,
    // );

    print('card-id size: ${cardIDFile.length()}');
    // final file = await ImageCrop.cropImage(
    //   file: File(cardIDFile.path),
    //   area: Rect.fromLTRB(20, 50, 20, 50),
    // );
    // print('crop size: ${file.length()}');

    String token = await ComeInAPI.initTokenOCR();
    Uint8List dataList = await cardIDFile.readAsBytes();
    String _key = await S3API.doUploadS3(dataList);
    UserConfirm? confirm =
        await ComeInAPI.scanIDCard(token, refId, dataList.toList());
    // confirm.
    print('finish scan');
  }

  doTakeImage(String bookno, String _refname, UserConfirm _conf,
      XFile cardIDFile, CardOverlay ovarlay) async {
    int cardSize = await cardIDFile.length();
    File srcFile = File(cardIDFile.path);
    Uint8List datas = await srcFile.readAsBytes();
    //FileImage idCardImage = FileImage(srcFile);

    print(srcFile);
    print('card-id size: ${cardSize}');
    // final file = await ImageCrop.cropImage(
    //   file: srcFile,
    //   area: Rect.fromLTRB(20, 50, 20, 50),
    // );
    //print('crop size: ${file.length()}');

    // img.Image? image = img.decodeJpg(datas.toList());
    // img.Image crop = img.copyCrop(image!, 100, 500, 200, 500);
    // List<int> cropJPG = img.encodeJpg(crop);
    // S3API.doUploadS3(Uint8List.fromList(cropJPG));
    // print(crop.length);

    Navigator.pushReplacementNamed(context, ROUTE_NAME_ADD_KYC_BOOKING,
        arguments: {
          "booking_no": bookno,
          "ref-name": _refname,
          "user_confirm": _conf,
          "idcard": cardIDFile.path
        });
  }

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    String _bookno = params['booking_no'];
    String _refname = params['ref-name'];
    UserConfirm _confirm = params['user_confirm'];
    print(
        'bookno-param= ${_bookno}, ref-id= ${_confirm.cardId}, ref-name= ${_refname}');
    return MaterialApp(
        home: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (value) {
          setState(() {
            tab = value;
          });
          switch (value) {
            case (0):
              setState(() {
                format = OverlayFormat.cardID1;
              });
              break;
            case (1):
              setState(() {
                format = OverlayFormat.cardID3;
              });
              break;
            // case (2):
            //   setState(() {
            //     format = OverlayFormat.simID000;
            //   });
            //   break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'National Card ID',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Passsport'),
          // BottomNavigationBarItem(icon: Icon(Icons.sim_card), label: 'Sim'),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No camera found',
                    style: TextStyle(color: Colors.black),
                  ));
            }
            return CameraOverlay(
                snapshot.data!.first,
                CardOverlay.byFormat(format),
                (XFile file) async => doTakeImage(_bookno, _refname, _confirm,
                    file, CardOverlay.byFormat(format)),
                // (XFile file) => showDialog(
                //       context: context,
                //       barrierColor: Colors.black,
                //       builder: (context) {
                //         CardOverlay overlay = CardOverlay.byFormat(format);
                //         return AlertDialog(
                //             actionsAlignment: MainAxisAlignment.center,
                //             backgroundColor: Colors.black,
                //             title: const Text('Capture',
                //                 style: TextStyle(color: Colors.white),
                //                 textAlign: TextAlign.center),
                //             actions: [
                //               OutlinedButton(
                //                   onPressed: () => Navigator.of(context).pop(),
                //                   child: const Icon(Icons.close))
                //             ],
                //             content: SizedBox(
                //                 width: double.infinity,
                //                 child: AspectRatio(
                //                   aspectRatio: overlay.ratio!,
                //                   child: Container(
                //                     decoration: BoxDecoration(
                //                         image: DecorationImage(
                //                       fit: BoxFit.fitWidth,
                //                       alignment: FractionalOffset.center,
                //                       image: FileImage(
                //                         File(file.path),
                //                       ),
                //                     )),
                //                   ),
                //                 )));
                //       },
                //     ),
                info:
                    'Position your ID card within the rectangle and ensure the image is perfectly readable.',
                label: 'Scanning ID Card');
          } else {
            return const Align(
                alignment: Alignment.center,
                child: Text(
                  'Fetching cameras',
                  style: TextStyle(color: Colors.black),
                ));
          }
        },
      ),
    ));
  }
}
