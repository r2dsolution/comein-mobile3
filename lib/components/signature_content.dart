import 'dart:typed_data';

import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:signature/signature.dart';

class SignaturePic extends StatefulWidget {
  final Function(Uint8List) onSignConfirm;

  const SignaturePic({Key? key, required this.onSignConfirm}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignaturePic();
  }
}

class _SignaturePic extends State<SignaturePic> {
  bool isUpload = false;
  bool isValid = false;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  late MemoryImage signImg;
  Uint8List? signData;

  doImage(Uint8List? img) {
    setState(() {
      signData = img;
      signImg = MemoryImage(img!);
      isUpload = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _signatureCanvas = Signature(
      controller: _controller,
      width: SizeConfig.screenWidth - 100,
      height: 180,
      backgroundColor: Colors.grey,
    );
    return Column(children: [
      ListTile(
        leading: Text("Step 4: draw Signature."),
        trailing: Icon(
            isUpload ? FontAwesomeIcons.checkSquare : FontAwesomeIcons.square),
      ),
      SizedBox(
        height: 180,
        width: SizeConfig.screenWidth - 100,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5.0),
          child: Stack(
            fit: StackFit.expand,
            //overflow: Overflow.visible,
            children: [
              // CircleAvatar(
              //   backgroundImage: AssetImage("assets/images/idCard.png"),
              //   // backgroundImage: MemoryImage(profileData),
              // ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  image: isUpload
                      ? DecorationImage(
                          image: signImg,
                          scale: 0.9,
                        )
                      : null,
                  // image: isUpload
                  //     ? DecorationImage(
                  //         image: AssetImage("assets/images/idCard.jpeg"),
                  //         fit: BoxFit.fill)
                  //     : null,
                  // image: DecorationImage(
                  //     image: AssetImage("assets/images/idCard.jpeg"),
                  //     fit: BoxFit.fill),
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                ),
              ),
              Center(
                child: isUpload
                    ? null
                    : SizedBox(
                        height: 46,
                        width: 46,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.white),
                          ),
                          color: Color(0xFFF5F6F9),
                          onPressed: () {
                            Alert(
                                desc: 'desc: Please sign',
                                context: context,
                                content: _signatureCanvas,
                                buttons: [
                                  DialogButton(
                                    onPressed: () => {
                                      _controller
                                          .toPngBytes()
                                          .then((value) => doImage(value)),
                                      Navigator.pop(context),
                                    },
                                    child: Text(
                                      "OK",
                                      // style: TextStyle(
                                      //     color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ]).show();
                            // setState(() {
                            //   isUpload = true;
                            // });
                          },
                          child: Icon(FontAwesomeIcons.fileSignature),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      // Text(isUpload
      //     ? (isValid ? "status: valid" : "status: not valid")
      //     : "no image."),
      Text(!isUpload ? "no signature" : ""),

      ListTile(
        leading: Text("Step 5: Confirm Signature."),
        trailing: Icon(
            isValid ? FontAwesomeIcons.checkSquare : FontAwesomeIcons.square),
      ),
      DefaultButton(
          text: 'Confirm Signature',
          enable: isUpload,
          press: () {
            setState(() {
              isValid = true;
            });
            widget.onSignConfirm(signData!);
          }),
      SizedBox(
        height: 40,
      )
    ]);
  }
}
