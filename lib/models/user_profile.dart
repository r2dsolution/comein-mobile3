import 'package:country_pickers/country.dart';

class UserProfile {
  final String firstname;
  final String lastname;
  final String refname;
  final String mobile;
  final Country country;

  String phone() {
    return '+' + country.phoneCode + mobile.substring(1, mobile.length);
  }

  UserProfile(
      this.firstname, this.lastname, this.refname, this.country, this.mobile);
}

class UserAccount {
  final UserProfile? profile;
  final String? email;

  UserAccount({this.profile, this.email});
}

class UserInfo {
  final String email;
  final String firstname;
  final String lastname;
  final String mobile;
  String _comeinId = '';
  String get comeinId => _comeinId;
  set comeinId(String str) {
    _comeinId = str;
  }

  UserInfo(this.email, this.firstname, this.lastname, this.mobile);
}
