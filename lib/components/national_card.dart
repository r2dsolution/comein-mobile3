import 'package:thecomein/models/user_confirm.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NationalCard extends StatefulWidget {
  final UserConfirm? Function() onLoadConfirm;

  const NationalCard({Key? key, required this.onLoadConfirm}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NationalCard();
  }
}

class _NationalCard extends State<NationalCard> {
  String birthDateStr = '-';
  String expireDateStr = '-';
  String name = '-';
  String cardIdStr = '-';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => doInitScreen(context));
  }

  doInitScreen(BuildContext c) {
    UserConfirm? confirm = widget.onLoadConfirm();
    if (confirm != null) {
      setState(() {
        birthDateStr =
            confirm.birthDate != '' ? confirm.birthDate : '01/01/2022';
        expireDateStr =
            confirm.expireDate != '' ? confirm.expireDate : '31/12/2022';
        name = '${confirm.namePrefix} ${confirm.firstname} ${confirm.lastname}';
        String _cardId = confirm.cardId != '' ? confirm.cardId : '0000000000';
        if (_cardId.length >= 13) {
          cardIdStr = _cardId.substring(0, 1) +
              '-' +
              _cardId.substring(1, 5) +
              '-' +
              _cardId.substring(5, 10) +
              '-' +
              _cardId.substring(10, 12) +
              '-' +
              _cardId.substring(12, 13);
        } else {
          cardIdStr = '9-9999-99999-99-9';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(birthDateStr);
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Icon(
                FontAwesomeIcons.user,
                size: 75,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name:', style: TextStyle(fontSize: 15.0)),
                Text(name, style: TextStyle(fontSize: 22.0)),
                Text('Card ID:', style: TextStyle(fontSize: 15.0)),
                Text('${cardIdStr}', style: TextStyle(fontSize: 22.0)),
                //Text('Card ID: ${widget.confirm.cardId}'),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex: 1, // 60% of space => (6/(6 + 4))
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        birthDateStr,
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Text(
                        'Birth Date',
                        style: TextStyle(fontSize: 15.0),
                      )
                    ],
                  ),
                  //alignment: Alignment(0.0, 0.0),
                ),
              ),
            ),
            Expanded(
              flex: 1, // 60% of space => (6/(6 + 4))
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        expireDateStr,
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Text(
                        'Expired Date',
                        style: TextStyle(fontSize: 15.0),
                      )
                    ],
                  ),
                  //alignment: Alignment(0.0, 0.0),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
