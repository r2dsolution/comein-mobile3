import 'package:thecomein/helper/datetime_utils.dart';
import 'package:thecomein/models/user_confirm.dart';
import 'package:intl/intl.dart';

class HotelProfile {
  final String name;
  final String shortName;
  final String address;
  final String assetImages;
  final String country;
  final String province;

  //HotelProfile(this.shortName, this.name, this.address, this.assetImages);
  HotelProfile()
      : name = '',
        shortName = '',
        address = '',
        country = '',
        province = '',
        assetImages = '';
  HotelProfile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        shortName = json['shortName'],
        address = json['address'],
        province = json['province'],
        country = json['country'],
        assetImages = json['image1-url'];
}

class TourProfile {
  final String name;
  final String shortName;
  final String address;
  List<String> assetImages = [];

  TourProfile(this.shortName, this.name, this.address);
  TourProfile.fromJson(dynamic json)
      : name = json['name'],
        shortName = '',
        address = json['address'],
        // assetImages = json['images'] as List<String>;
        assetImages = [];
}

class HotelBooking {
  final int id;
  final String bookNO;
  final String customer;
  final String customer2;
  final HotelProfile hotel;
  final int visitorChild;
  final int visitorAdult;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String _checkIn = '';
  final String _checkOut = '';

  final String roomName;
  final String roomDesc;
  final List kycCardId;

  String _targetEmail = '';

  String get checkIn =>
      checkInDate == null ? '' : DateFormat('yyyy-MM-dd').format(checkInDate!);

  String get checkOut => checkOutDate == null
      ? ''
      : DateFormat('yyyy-MM-dd').format(checkOutDate!);

  String get targetEmail => _targetEmail;

  set targetEmail(String targetEmail) {
    _targetEmail = targetEmail;
  }

  String _targetName = '';

  String get targetName => _targetName;

  set targetName(String targetName) {
    _targetName = targetName;
  }

  List<UserConfirm> _confirmList = [];

  List<UserConfirm> get userConfirm => _confirmList;

  UserConfirm doEmail2Json(dynamic json, String _email) {
    print('doEmail2Json - email : ${_email}');
    //  print('json -> ' + json);
    dynamic confirm_json = json[_email];
    return UserConfirm.fromJson(confirm_json);
  }

  addUserConfirm(dynamic json) {
    List list = json['kyc-email'] as List;
    List<UserConfirm> dataList =
        list.map((_email) => doEmail2Json(json['kyc-info'], _email)).toList();

    _confirmList.addAll(dataList);

    // json[''] as list;
    // UserConfirm confirm = UserConfirm.fromJson(json);
  }

  HotelBooking()
      : id = 0,
        bookNO = '',
        customer = '',
        customer2 = '',
        hotel = HotelProfile(),
        visitorAdult = 0,
        visitorChild = 0,
        checkInDate = null,
        checkOutDate = null,
        roomName = '',
        roomDesc = '',
        kycCardId = [];

  HotelBooking.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookNO = json['book-no'],
        customer = json['ref-name'],
        customer2 = json['ref-name2'],
        // hotel = HotelProfile(),
        hotel = json.containsKey('hotel')
            ? HotelProfile.fromJson(json['hotel'])
            : HotelProfile(),
        visitorAdult = json['visitor-adult'],
        visitorChild = json['visitor-child'],
        checkInDate = ComeInDateUtils.toDateTime(json['check-in']),
        checkOutDate = ComeInDateUtils.toDateTime(json['check-out']),
        roomName = json['room-name'],
        roomDesc = json['room-desc'],
        // _targetEmail = json['customer-email'],
        kycCardId = json['card-id'] as List;

  void initUserConfirm(UserConfirm c) {
    _confirmList.add(c);
  }
}

class TourBooking {
  final String bookNO;
  final DateTime tourDate;
  final TourProfile tour;

  TourBooking(this.bookNO, this.tourDate, this.tour);
}

class TourInfo {
  final String name;
  final String description;
  final String durationTime;
  final String cost;
  final TourProfile agency;
  List<TourImageInfo> _images = [];
  List<TourImageInfo> get images => _images;
  set images(List<TourImageInfo> pics) {
    _images = pics;
  }

  TourInfo(
      this.name, this.description, this.durationTime, this.cost, this.agency);

  TourInfo.fromJson(dynamic json)
      : name = json['name'],
        description = json['description'],
        durationTime = json['duration-time'],
        cost = json['ticket-value'],
        agency = TourProfile.fromJson(json['agency']);
}

class TourImageInfo {
  final String url;
  final int id;

  TourImageInfo(
    this.id,
    this.url,
  );
}
