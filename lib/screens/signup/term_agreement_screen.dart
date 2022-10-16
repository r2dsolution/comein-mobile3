import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/message.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/size_config.dart';
import 'package:thecomein/theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

class TermAgreementScreen extends StatelessWidget {
  static String routeName = ROUTE_NAME_SIGNUP_AGREEMENT;

  const TermAgreementScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    final String agreemntLabel = appLocale.agreement;
    return Scaffold(
      appBar: AppBar(
        // leading: SizedBox(),
        title: Text(
          agreemntLabel,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(),
    );
  }
}

const htmlData = r"""
<b>Use of this Site constitutes agreement with the following terms and conditions.</b><br/>
<br/>
1. BOT maintains this web site (the "Site") as a courtesy to those who may choose to access the Site ("Users"). The information presented herein is for informative purposes only. BOT is pleased to allow Users to visit the Site and download and copy the information, documents and materials (collectively, "Materials") from the Site for User use subject to the terms and conditions outlined below, and also subject to more specific restrictions that may apply to specific material within this Site.
</br>
<br/>2. Unless expressly stated otherwise, the findings interpretations and conclusions expressed in the Materials in this Site are those of the various authors of the work and are not necessarily those of BOT.

Condition of use
</br>
<br/>3. Unless expressly stated otherwise, the findings interpretations and conclusions expressed in the Materials in this Site are those of the various authors of the work and are not necessarily those of BOT.

Condition of use
</br>
<br/>4. Unless expressly stated otherwise, the findings interpretations and conclusions expressed in the Materials in this Site are those of the various authors of the work and are not necessarily those of BOT.

Condition of use
</br>
<br/>5. Unless expressly stated otherwise, the findings interpretations and conclusions expressed in the Materials in this Site are those of the various authors of the work and are not necessarily those of BOT.

Condition of use
</br>
<br/>6. Unless expressly stated otherwise, the findings interpretations and conclusions expressed in the Materials in this Site are those of the various authors of the work and are not necessarily those of BOT.

Condition of use
<br/>
""";

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BodyState();
  }
}

class BodyState extends State<Body> {
  bool accept = false;
  @override
  Widget build(BuildContext context) {
    //final AppLocalizations? appLocale = AppLocalizations.of(context);
    var appLocale = appMsg(context);
    final String agreemntLabel = appLocale!.agreement;
    final String iAcceptLabel = appLocale.i_accept;
    final String nextLabel = appLocale.next;
    return SafeArea(
      //child: SingleChildScrollView(
      child: Column(
        children: [
          // SizedBox(height: SizeConfig.screenHeight * 0.04),
          // Image.asset(
          //   "assets/images/success.png",
          //   height: SizeConfig.screenHeight * 0.4, //40%
          // ),
          // Text(
          //   agreemntLabel,
          //   style: Theme.of(context).textTheme.headline3,
          // ),
          // SpaceBox(
          //   height: 2,
          // ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: kBGPrimaryColor,
              height: getPercentScreenHeight(70),
              child:
                  //Html(data: htmlData)
                  SingleChildScrollView(
                child: Html(data: htmlData),
              )

              //   TextField(
              //   controller: TextEditingController(
              //       text:
              //           'ข้อกำหนดและเงื่อนไข / Terms and Conditions Noble Cosper Co., Ltd. จัดทำเนื้อหาและให้บริการบนเว็บไซต์แก่ท่านภายใต้ข้อกำหนดและเงื่อนไข ต่อไปนี้ นโยบายความเป็นส่วนตัวของบริษัท และข้อกำหนดและเงื่อนไขอื่น รวมทั้งนโยบายต่างๆ ที่ท่านจะหาได้ทั่วเว็บไซต์ของบริษัทในส่วนที่เกี่ยวกับการใช้งาน รูปแบบ และการส่งเสริมการขายบางประการ รวมทั้งการบริการลูกค้า ซึ่งทั้งหมดถือเป็นส่วนหนึ่งและรวมอยู่ในข้อกำหนดและเงื่อนไขเหล่านี้ (รวมเรียกว่า “ข้อกำหนดและเงื่อนไข”) โดยการเข้าใช้เว็บไซต์ ท่านยอมรับว่าท่านได้อ่าน เข้าใจและตกลงที่จะผูกพันตามข้อกำหนดและเงื่อนไขเหล่านี้โดยไม่จำกัด'),
              //   keyboardType: TextInputType.multiline,
              //   textInputAction: TextInputAction.newline,
              //   minLines: 1,
              //   maxLines: 30,
              //   readOnly: true,
              // ),
              ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          //Spacer(),
          ListTile(
            title: Row(
              children: [
                Checkbox(
                  value: accept,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      accept = value!;
                    });
                  },
                ),
                Text(iAcceptLabel)
              ],
            ),
            onTap: () => {
              setState(() {
                accept = !accept;
              })
            },
          ),
          // Row(
          //   children: [
          //     Checkbox(
          //       value: accept,
          //       activeColor: kPrimaryColor,
          //       onChanged: (value) {
          //         setState(() {
          //           accept = value!;
          //         });
          //       },
          //     ),
          //     Text(iAcceptLabel)
          //   ],
          // ),

          // Text(
          //   "Login Success",
          //   style: TextStyle(
          //     fontSize: getProportionateScreenWidth(30),
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: DefaultButton(
                enable: accept,
                text: nextLabel,
                press: () {
                  Navigator.pushNamed(context, ROUTE_NAME_SIGNUP_PROFIE);
                },
              ),
            ),
          ),
          Spacer(),
        ],
      ),
      // ),
    );
  }
}
