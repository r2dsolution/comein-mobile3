// import 'package:thecomein/components/card_id_overlay.dart';
// import 'package:thecomein/models/hotel_profile.dart';
// import 'package:thecomein/screens/hotel_booking_screen.dart';
// import 'package:thecomein/screens/hotels/confirm_hotel_booking.dart';
// import 'package:thecomein/screens/hotels/detail_hotel_booking_screen.dart';
// import 'package:thecomein/screens/hotels/forward_hotel_booking.dart';
import 'package:thecomein/components/card_id_overlay.dart';
import 'package:thecomein/screens/activities_main_screen.dart';
import 'package:thecomein/screens/booking_main_screen.dart';
import 'package:thecomein/screens/forgot_password/forgot_password_otp_screen.dart';
import 'package:thecomein/screens/forgot_password/forgot_password_screen.dart';
import 'package:thecomein/screens/hotels/forward/forward_hotel_booking.dart';
import 'package:thecomein/screens/hotels/kyc/add_kyc_booking.dart';
import 'package:thecomein/screens/hotels/view/detail_hotel_booking_screen.dart';
import 'package:thecomein/screens/lunching_page_screen.dart';
import 'package:thecomein/screens/profile/change_password/change_password.dart';
import 'package:thecomein/screens/profile/change_password/change_password_confirm.dart';
import 'package:thecomein/screens/profile/edit/edit_profile_screen.dart';
import 'package:thecomein/screens/profile/edit/view_profile_screen.dart';
// import 'package:thecomein/screens/password/change_password_confirm.dart';
// import 'package:thecomein/screens/password/forgot_password_otp_screen.dart';
// import 'package:thecomein/screens/password/forgot_password_screen.dart';
// import 'package:thecomein/screens/password/change_password.dart';
// import 'package:thecomein/screens/profile/edit_profile_screen.dart';
// import 'package:thecomein/screens/profile/view_profile_screen.dart';
import 'package:thecomein/screens/signin_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:thecomein/screens/signup/profile_screen.dart';
import 'package:thecomein/screens/signup/otp_screen.dart';
import 'package:thecomein/screens/signup/account_screen.dart';
import 'package:thecomein/screens/signup/term_agreement_screen.dart';
import 'package:thecomein/screens/tour_main_screen.dart';
// import 'package:thecomein/screens/tour_booking_screen.dart';
// import 'package:thecomein/screens/tours/detail_tour_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  // SplashScreen.routeName: (context) => SplashScreen(),
  ROUTE_NAME_SIGNIN: (context) => const SignInScreen(),
  ROUTE_NAME_LUNCHING_PAGE: (context) => const LunchingPageScreen(),
  ROUTE_NAME_MAIN_BOOKING: (context) => const MainBookingScreen(),
  ROUTE_NAME_TOUR_BOOKING: (context) => const TourMainScreen(),
  ROUTE_NAME_FORWARD_HOTEL_BOOKING: (context) =>
      const ForwardHotelBookingScreen(),
  ROUTE_NAME_DETAIL_HOTEL_BOOKING: (context) =>
      const DetailHotelBookingScreen(),
  ROUTE_NAME_ADD_KYC_BOOKING: (context) => const AddKYCBookingScreen(),
  // ROUTE_NAME_CONFIRM_HOTEL_BOOKING: (context) =>
  //     const ConfirmHotelBookingScreen(),
  ROUTE_NAME_OCR_CARD_ID: (context) => const CardIDCameraOverlay(),

  ROUTE_NAME_SIGNUP_AGREEMENT: (context) => const TermAgreementScreen(),
  ROUTE_NAME_SIGNUP_PROFIE: (context) => const SignUpProfileScreen(),
  ROUTE_NAME_SIGNUP_ACCOUNT: (context) => const SignUpAccountScreen(),
  ROUTE_NAME_SIGNUP_OTP: (context) => const SignUpOtpScreen(),

  ROUTE_NAME_PASSWORD_FORGOT: (context) => const ForgotPasswordScreen(),
  ROUTE_NAME_PASSWORD_OTP: (context) => const ForgetPasswordOtpScreen(),
  ROUTE_NAME_PASSWORD_CHANGE: (context) => const ChangePasswordScreen(),
  ROUTE_NAME_PASSWORD_CONFIRM_CHANGE: (context) =>
      const ConfirmChangePasswordScreen(),

  ROUTE_NAME_PROFILE_VIEW: (context) => const ProfileScreen(),
  ROUTE_NAME_PROFILE_EDIT: (context) => const EditProfileScreen(),

  ROUTE_NAME_ACTIVITIES_BOARD: (context) => const ActivitiesMainScreen(),

  // ROUTE_NAME_TOUR_DETAIL: (context) => const DetailTourScreen(),
};
const String ROUTE_NAME_SIGNIN = '"/sign_in"';
//const String ROUTE_NAME_TERM_AGREEMENT = '';
const String ROUTE_NAME_MAIN_BOOKING = '/main_booking';
const String ROUTE_NAME_TOUR_BOOKING = '/tour_booking';
const String ROUTE_NAME_PROFILE_VIEW = '/profile/view';
const String ROUTE_NAME_PROFILE_EDIT = '/profile/edit';

const String ROUTE_NAME_LUNCHING_PAGE = '/lunching_page';

const String ROUTE_NAME_TOUR_DETAIL = '/tours/detail_tour';
const String ROUTE_NAME_FORWARD_HOTEL_BOOKING = '/hotels/forward_booking';
const String ROUTE_NAME_DETAIL_HOTEL_BOOKING = '/hotels/detail_booking';
const String ROUTE_NAME_CONFIRM_HOTEL_BOOKING = '/hotels/confirm_booking';
const String ROUTE_NAME_ADD_KYC_BOOKING = '/kyc-info/add_kyc_booking';
const String ROUTE_NAME_OCR_CARD_ID = '/kyc-info/ocr_card_id';
const String ROUTE_NAME_SIGNUP_PROFIE = '/signup/profile';
const String ROUTE_NAME_SIGNUP_AGREEMENT = '/signup/agreement';
const String ROUTE_NAME_SIGNUP_ACCOUNT = '/signup/account';
const String ROUTE_NAME_SIGNUP_OTP = '/signup/otp';
const String ROUTE_NAME_PASSWORD_FORGOT = '/password/forgot';
const String ROUTE_NAME_PASSWORD_OTP = '/password/otp';
const String ROUTE_NAME_PASSWORD_CHANGE = '/password/change';
const String ROUTE_NAME_PASSWORD_CONFIRM_CHANGE = '/password/confirm_change';

const String ROUTE_NAME_ACTIVITIES_BOARD = '/activities';
