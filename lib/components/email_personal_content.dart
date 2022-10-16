import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/national_card.dart';

import 'package:thecomein/models/user_confirm.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailPersonalContent extends StatefulWidget {
  final Function(UserConfirm) onChangeConfirm;
  final UserConfirm? Function() onLoadConfirm;
  final String displayName;

  const EmailPersonalContent(
      {Key? key,
      required this.displayName,
      required this.onChangeConfirm,
      required this.onLoadConfirm})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EmailPersonalContent();
  }
}

class _EmailPersonalContent extends State<EmailPersonalContent> {
  bool isValid = false;
  bool isEmail = false;
  TextEditingController email = new TextEditingController(text: '');
  //TextEditingController displayName = new TextEditingController(text: '');
  TextEditingController firstname = new TextEditingController(text: '');
  TextEditingController lastname = new TextEditingController(text: '');
  TextEditingController idcard = new TextEditingController(text: '');
  UserConfirm? personInfo;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => doInitScreen(context));
  }

  doInitScreen(BuildContext context) {
    print('init screen');
    final params = ModalRoute.of(context)!.settings.arguments as Map;

    UserConfirm? _user = widget.onLoadConfirm();
    setState(() {
      personInfo = _user;
    });
    if (personInfo != null) {
      firstname.text = personInfo!.firstname;
      lastname.text = personInfo!.lastname;
      idcard.text = personInfo!.cardId;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build screen');
    //final params = ModalRoute.of(context)!.settings.arguments as Map;

    return Column(children: [
      // Container(
      //     alignment: Alignment.centerLeft,
      //     child: Padding(
      //         padding: const EdgeInsets.fromLTRB(20, 0, 0, 10.0),
      //         child: Text("Step 2: Fill User Information."))),
      ListTile(
        leading: Text("Step 3: Validate User Information."),
        trailing: Icon(
            isValid ? FontAwesomeIcons.checkSquare : FontAwesomeIcons.square),
      ),
      Container(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(children: [
              // UserDropDown(),
              SizedBox(
                height: 10,
              ),
              // (params.containsKey('confirm_info'))
              //     ? DefaultTextFeild(
              //         hintLabel: 'Enter your email',
              //         textLabel: 'email',
              //         svgIcon: 'assets/icons/Mail.svg',
              //         textController: email,
              //         isReadOnly: true,
              //       )
              //     : EmailTextFeild(
              //         textController: email,
              //         changeEvent: (_value) {
              //           setState(() {
              //             isEmail = true;
              //           });
              //         },
              //       ),
              EmailTextFeild(
                textController: email,
                saveEvent: (_value) {
                  print('save email');
                },
                validateEvent: (_value) {
                  print('valid email');
                },
                changeEvent: (_value) {
                  print('change email');
                  setState(() {
                    isEmail = true;
                  });
                },
              ),
              // DefaultTextFeild(
              //   hintLabel: 'Enter your display name',
              //   textLabel: 'display name',
              //   svgIcon: 'assets/icons/Mail.svg',
              //   textController: displayName,
              //   isReadOnly: false,
              // ),
              NationalCard(
                onLoadConfirm: widget.onLoadConfirm,
              ),
              // ListTile(
              //   subtitle:
              //       Text(personInfo != null ? personInfo!.firstname : '-'),
              //   title: Text('Firstname:'),
              //   trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              //   //   trailing:
              //   //       Text(personInfo != null ? personInfo!.firstname : '-'),
              // ),
              // ListTile(
              //   subtitle: Text(personInfo != null ? personInfo!.lastname : '-'),
              //   title: Text('Lastname:'),
              //   trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              // ),
              // ListTile(
              //   subtitle: Text(personInfo != null ? personInfo!.cardId : '-'),
              //   title: Text('Card ID:'),
              //   trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              // ),

              DefaultButton(
                  text: 'Validate Information',
                  enable: isEmail,
                  press: () {
                    // print('hide-keyboard');
                    // KeyboardUtil.hideKeyboard(context);
                    print('validate name,email');
                    print('display-name=${widget.displayName}');
                    print('firstname=${firstname.text}');
                    setState(() {
                      isValid = true;
                      // UserConfirm u = UserConfirm(
                      //     firstname.text, lastname.text, 'TH', email.text, '201');
                      if (personInfo != null) {
                        personInfo!.email = email.text;
                        personInfo!.firstname = firstname.text;
                        personInfo!.lastname = lastname.text;
                        personInfo!.displayName = widget.displayName;
                        widget.onChangeConfirm(personInfo!);
                      }
                    });
                    //widget.onConfirm();
                  }),
              SizedBox(
                height: 40,
              )
            ]),
          ))
    ]);
  }
}
