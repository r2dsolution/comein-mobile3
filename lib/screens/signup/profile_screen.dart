import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/form_error.dart';
import 'package:thecomein/constants.dart';
import 'package:thecomein/components/message.dart';
import 'package:thecomein/models/user_profile.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';

import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';

class SignUpProfileScreen extends StatefulWidget {
  static String routeName = ROUTE_NAME_SIGNUP_PROFIE;

  const SignUpProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpProfileScreen();
  }
}

class _SignUpProfileScreen extends DefaultScreen<SignUpProfileScreen> {
  @override
  Widget widgetBody(BuildContext context, OnLoadingCallback loading) {
    return Body(
      onLoading: loading,
    );
  }
}

class Body extends StatelessWidget {
  final OnLoadingCallback onLoading;

  const Body({Key? key, required this.onLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppLocalizations? appLocale = AppLocalizations.of(context);
    var appLocale = appMsg(context);
    final String userProfileLabel = appLocale!.user_profile;
    final String userProfileTextLabel = appLocale.user_profile_text;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              // Text(
              //   userProfileLabel,
              //   style: Theme.of(context).textTheme.headline4,
              // ),
              // Text(
              //     userProfileTextLabel,
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: fontSizeText1),
              //   ),
              DefaultTopicText(
                  label: userProfileLabel, subLabel: userProfileTextLabel),
              SizedBox(height: SizeConfig.screenHeight * 0.06),
              CompleteProfileForm(
                submit: (_value) => doNext(context, _value),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),

              // Text(
              //   "By continuing your confirm that you agree \nwith our Term and Condition",
              //   textAlign: TextAlign.center,
              //   style: Theme.of(context).textTheme.caption,
              // ),
            ],
          )),
        ),
      ),
    );
  }

  doNext(BuildContext context, UserProfile profile) {
    var phone = profile.phone();
    print('phone-no: $phone');
    onLoading(true);
    Future.delayed(
        loadingTimes,
        () => {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SignUpScreen(),
              //     settings: RouteSettings(
              //       arguments: profile,
              //     ),
              //   ),
              // ),
              Navigator.pushNamed(
                context,
                ROUTE_NAME_SIGNUP_ACCOUNT,
                arguments: profile,
              ),
              onLoading(false),
            });
  }
}

class CompleteProfileForm extends StatefulWidget {
  final Function(UserProfile) submit;

  const CompleteProfileForm({Key? key, required this.submit}) : super(key: key);

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final TextEditingController firstnameController = new TextEditingController();
  final TextEditingController lastnameController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('66');

  void addError({required String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({required String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    //final AppLocalizations? appLocale = AppLocalizations.of(context);
    var appLocale = appMsg(context);
    final String nextLabel = appLocale!.next;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // buildFirstNameFormField(appLocale),
          DefaultTextFeild(
            textController: firstnameController,
            svgIcon: "assets/icons/User.svg",
            hintLabel: appLocale.first_name_hint,
            textLabel: appLocale.first_name,
            changeEvent: (_value) => {
              if (_value!.isNotEmpty)
                {
                  removeError(error: appLocale.first_name_required),
                }
            },
            validateEvent: (_value) {
              if (_value!.isEmpty) {
                addError(error: appLocale.first_name_required);
                return "";
              }
              return null;
            },
          ),
          // SizedBox(height: getProportionateScreenHeight(30)),
          DefaultTextFeild(
            textController: lastnameController,
            svgIcon: "assets/icons/User.svg",
            hintLabel: appLocale.last_name_hint,
            textLabel: appLocale.last_name,
            changeEvent: (_value) => {
              if (_value!.isNotEmpty)
                {
                  removeError(error: appLocale.last_name_required),
                }
            },
            validateEvent: (_value) {
              if (_value!.isEmpty) {
                addError(error: appLocale.last_name_required);
                return "";
              }
              return null;
            },
          ),
          DefaultTextFeild(
            textController: nameController,
            svgIcon: "assets/icons/User.svg",
            hintLabel: appLocale.ref_name_hint,
            textLabel: appLocale.ref_name,
            changeEvent: (_value) => {
              if (_value!.isNotEmpty)
                {
                  removeError(error: appLocale.ref_name_required),
                }
            },
            validateEvent: (_value) {
              if (_value!.isEmpty) {
                addError(error: appLocale.ref_name_required);
                return "";
              }
              return null;
            },
          ),
          // buildLastNameFormField(appLocale),
          //SizedBox(height: getProportionateScreenHeight(30)),
          // buildPhoneNumberFormField(appLocale),
          DefaultPhoneFeild(
            textController: phoneController,
            svgIcon: "assets/icons/Phone.svg",
            hintLabel: appLocale.phone_number_hint,
            textLabel: appLocale.phone_number,
            // inputType: TextInputType.phone,
            phoneCountry: _selectedDialogCountry,
            countryEvent: (_value) => {
              setState(() => _selectedDialogCountry = _value),
              print('hello $_selectedDialogCountry'),
            },
            changeEvent: (_value) => {
              if (_value!.isNotEmpty)
                {
                  removeError(error: appLocale.phone_number_required),
                },
              if (phoneValidatorRegExp.hasMatch(_value))
                {
                  removeError(error: appLocale.phone_number_invalid),
                }
            },
            validateEvent: (_value) {
              print('phone: $_value');
              if (_value!.isEmpty) {
                addError(error: appLocale.phone_number_required);
                return "";
              }
              if (!phoneValidatorRegExp.hasMatch(_value)) {
                addError(error: appLocale.phone_number_invalid);
                return "";
              }
              return null;
            },
          ),
          //SizedBox(height: getProportionateScreenHeight(30)),
          // buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: nextLabel,
            press: () {
              if (_formKey.currentState!.validate()) {
                // Navigator.pushNamed(context, SignUpScreen.routeName);
                UserProfile _profile = UserProfile(
                    firstnameController.text,
                    lastnameController.text,
                    nameController.text,
                    _selectedDialogCountry,
                    phoneController.text);
                widget.submit(_profile);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SignUpScreen(),
                //     settings: RouteSettings(
                //       arguments: UserProfile(firstnameController.text,
                //           lastnameController.text, phoneController.text),
                //     ),
                //   ),
                // );
              }
            },
          ),
        ],
      ),
    );
  }

  // void _openCountryPickerDialog() => showDialog(
  //       context: context,
  //       builder: (context) => Theme(
  //           data: Theme.of(context).copyWith(primaryColor: Colors.pink),
  //           child: CountryPickerDialog(
  //               titlePadding: EdgeInsets.all(8.0),
  //               searchCursorColor: Colors.pinkAccent,
  //               searchInputDecoration: InputDecoration(hintText: 'Search...'),
  //               isSearchable: true,
  //               title: Text('Select your phone code'),
  //               onValuePicked: (Country country) =>
  //                   setState(() => _selectedDialogCountry = country),
  //               // itemFilter: (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
  //               // priorityList: [
  //               //   CountryPickerUtils.getCountryByIsoCode('TR'),
  //               //   CountryPickerUtils.getCountryByIsoCode('US'),
  //               // ],
  //               itemBuilder: _buildDialogItem)),
  //     );
  // Widget _buildDialogItem(Country country) => Row(
  //       children: <Widget>[
  //         CountryPickerUtils.getDefaultFlagImage(country),
  //         SizedBox(width: 8.0),
  //         Text("+${country.phoneCode}"),
  //         SizedBox(width: 8.0),
  //         Flexible(child: Text(country.name))
  //       ],
  //     );
  // Widget _buildSelectDialogItem(Country country) => Row(
  //       children: <Widget>[
  //         CountryPickerUtils.getDefaultFlagImage(country),
  //         SizedBox(width: 8.0),
  //         Text("+${country.phoneCode}"),
  //         //SizedBox(width: 8.0),
  //         // Flexible(child: Text(country.name))
  //       ],
  //     );
  // TextFormField buildAddressFormField() {
  //   return TextFormField(
  //     onSaved: (newValue) => address = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kAddressNullError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kAddressNullError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Address",
  //       hintText: "Enter your phone address",
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon:
  //           CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
  //     ),
  //   );
  // }

  // TextFormField buildPhoneNumberFormField(AppLocalizations appLocale) {
  //   final String phoneLabel = appLocale.phone_number;
  //   final String phoneHintLabel = appLocale.phone_number_hint;
  //   return TextFormField(
  //     keyboardType: TextInputType.phone,
  //     onSaved: (newValue) => phoneNumber = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kPhoneNumberNullError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kPhoneNumberNullError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: phoneLabel,
  //       hintText: phoneHintLabel,
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
  //     ),
  //   );
  // }

  // TextFormField buildLastNameFormField(AppLocalizations appLocale) {
  //   final String lastNameLabel = appLocale.last_name;
  //   final String lastNameHintLabel = appLocale.last_name_hint;
  //   return TextFormField(
  //     onSaved: (newValue) => lastName = newValue,
  //     decoration: InputDecoration(
  //       labelText: lastNameLabel,
  //       hintText: lastNameHintLabel,
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
  //     ),
  //   );
  // }

  // TextFormField buildFirstNameFormField(AppLocalizations appLocale) {
  //   final String firstNameLabel = appLocale.first_name;
  //   final String firstNameHintLabel = appLocale.first_name_hint;
  //   return TextFormField(
  //     onSaved: (newValue) => firstName = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kNamelNullError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kNamelNullError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: firstNameLabel,
  //       hintText: firstNameHintLabel,
  //       helperText: ' ',
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
  //     ),
  //   );
  // }
}
