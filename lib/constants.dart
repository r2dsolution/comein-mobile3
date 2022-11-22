const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kFirstNamelNullError = "Please Enter your firstname";
const String kLastNamelNullError = "Please Enter your lastname";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kPhoneNumberDigitError = "Please Enter Valid phone number";
const String kAddressNullError = "Please Enter your address";
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9][a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

final RegExp phoneValidatorRegExp = RegExp(r"^[0-9]{10}$");

enum MenuState {
  home,
  hotelBooking,
  tourBooking,
  favourite,
  activities,
  profile
}
