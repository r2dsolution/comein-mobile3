import 'package:thecomein/models/user_profile.dart';

class UserConfirm {
  UserConfirm.from(UserInfo profile)
      : _firstname = profile.firstname,
        _lastname = profile.lastname,
        _name = profile.firstname + ' ' + profile.lastname,
        _email = profile.email,
        cardId = '',
        cardType = '',
        language = 'TH';
  UserConfirm(this.cardId, this.cardType, this.language)
  // : _name = '',
  //   _email = ''
  ;

  //String _title = '';
  String _firstname = '';
  String _lastname = '';
  String _displayName = '';
  String _name = '';
  String _gender = '';
  String _namePrefix = '';
  String _email = '';
  String _birthDate = '';
  String _expireDate = '';
  final String language;
  String _namePrefix2 = '';
  String _firstname2 = '';
  String _lastname2 = '';
  String _language2 = '';
  final String cardId;
  final String cardType;
  bool _isConfirm = false;
  bool _isValid = true;
  bool _isEdit = true;
  bool _isDelete = true;
  String _refImage = '';
  String _signImage = '';

  bool get isEdit => _isEdit;

  set isEdit(bool isEdit) {
    _isEdit = isEdit;
  }

  bool get isDelete => _isDelete;

  set isDelete(bool isDelete) {
    _isDelete = isDelete;
  }

  bool get isValid => _isValid;

  set isValid(bool isValid) {
    _isValid = isValid;
  }

  bool get isConfirm => _isConfirm;

  set isConfirm(bool isConfirm) {
    _isConfirm = isConfirm;
  }

  String get email => _email;
  set email(_value) {
    _email = _value;
  }

  String get gender => _gender;
  set gender(_value) {
    _gender = _value;
  }

  String get namePrefix => _namePrefix;
  set namePrefix(_value) {
    _namePrefix = _value;
  }

  String get namePrefix2 => _namePrefix2;
  set namePrefix2(_value) {
    _namePrefix2 = _value;
  }

  String get birthDate => _birthDate;
  set birthDate(_value) {
    _birthDate = _value;
  }

  String get expireDate => _expireDate;
  set expireDate(_value) {
    _expireDate = _value;
  }

  String get language2 => _language2;
  set language2(_value) {
    _language2 = _value;
  }

  String get firstname2 => _firstname2;
  set firstname2(_value) {
    _firstname2 = _value;
  }

  String get lastname2 => _lastname2;
  set lastname2(_value) {
    _lastname2 = _value;
  }

  String get firstname => _firstname;
  set firstname(_value) {
    _firstname = _value;
  }

  String get lastname => _lastname;
  set lastname(_value) {
    _lastname = _value;
  }

  String get name => _name;
  set name(_value) {
    _name = _value;
  }

  String get displayName => _displayName;
  set displayName(_value) {
    _displayName = _value;
  }

  String get refImage => _refImage;
  set refImage(_value) {
    _refImage = _value;
  }

  String get signImage => _signImage;
  set signImage(_value) {
    _signImage = _value;
  }

  String toJson() {
    return '{"email":"${_email}","title":"${_namePrefix}","firstname":"${_firstname}","lastname":"${_lastname}","name":"${name}","birthdate":"${_birthDate}","display-name":"${_displayName}","card-id":"${cardId}","card-type":"${cardType}","card-expire-date":"${_expireDate}","language":"${language}","ref-image":"${_refImage}","sign-image":"${_signImage}"}';
  }

  // UserConfirm.fromJson(dynamic json)
  //     : _firstname = json['firstname'],
  //       _lastname = json['lastname'],
  //       _name = json['firstname'] + ' ' + json['lastname'],
  //       _email = json['email'],
  //       cardId = json['ref-id'],
  //       cardType = json['ref-type'],
  //       language = 'TH';

  UserConfirm.fromJson(dynamic json)
      : cardId = json['ref-id'],
        cardType = json['ref-type'],
        _displayName = json['display-name'],
        language = 'TH';

  UserConfirm.fromIDCardOCR(dynamic json)
      : _firstname = json['FirstNameTH'],
        _firstname2 = json['FirstNameENG'],
        _lastname = json['LastNameTH'],
        _lastname2 = json['LastNameENG'],
        _name = json['FirstNameTH'] + ' ' + json['LastNameTH'],
        language = 'TH',
        _language2 = 'EN',
        cardId = json['IdentificationNumber'],
        cardType = 'ID_CARD',
        _email = '',
        _namePrefix = json['PrefixTH'],
        _namePrefix2 = json['PrefixENG'],
        _birthDate = json['BirthDate'],
        _expireDate = json['ExpirationDate'];
}
