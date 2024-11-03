class User {
  Id? _iId;
  String? _userId;
  String? _userName;
  String? _email;
  String? _password;
  String? _address;
  int? _role;
  String? _phoneNumber;
  int? _iV;
  List<Null>? _addresses;

  User(
      {Id? iId,
      String? userId,
      String? userName,
      String? email,
      String? password,
      String? address,
      int? role,
      String? phoneNumber,
      int? iV,
      List<Null>? addresses}) {
    if (iId != null) {
      this._iId = iId;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (userName != null) {
      this._userName = userName;
    }
    if (email != null) {
      this._email = email;
    }
    if (password != null) {
      this._password = password;
    }
    if (address != null) {
      this._address = address;
    }
    if (role != null) {
      this._role = role;
    }
    if (phoneNumber != null) {
      this._phoneNumber = phoneNumber;
    }
    if (iV != null) {
      this._iV = iV;
    }
    if (addresses != null) {
      this._addresses = addresses;
    }
  }

  Id? get iId => _iId;
  set iId(Id? iId) => _iId = iId;
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get userName => _userName;
  set userName(String? userName) => _userName = userName;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get password => _password;
  set password(String? password) => _password = password;
  String? get address => _address;
  set address(String? address) => _address = address;
  int? get role => _role;
  set role(int? role) => _role = role;
  String? get phoneNumber => _phoneNumber;
  set phoneNumber(String? phoneNumber) => _phoneNumber = phoneNumber;
  int? get iV => _iV;
  set iV(int? iV) => _iV = iV;
  List<Null>? get addresses => _addresses;
  set addresses(List<Null>? addresses) => _addresses = addresses;

  User.fromJson(Map<String, dynamic> json) {
    _iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    _userId = json['user_id'];
    _userName = json['user_name'];
    _email = json['email'];
    _password = json['password'];
    _address = json['address'];
    _role = json['role'];
    _phoneNumber = json['phone_number'];
    _iV = json['__v'];
    if (json['addresses'] != null) {
      _addresses = <Null>[];
      json['addresses'].forEach((v) {
        _addresses!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._iId != null) {
      data['_id'] = this._iId!.toJson();
    }
    data['user_id'] = this._userId;
    data['user_name'] = this._userName;
    data['email'] = this._email;
    data['password'] = this._password;
    data['address'] = this._address;
    data['role'] = this._role;
    data['phone_number'] = this._phoneNumber;
    data['__v'] = this._iV;
    if (this._addresses != null) {
      data['addresses'] = this._addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Id {
  String? _oid;

  Id({String? oid}) {
    if (oid != null) {
      this._oid = oid;
    }
  }

  String? get oid => _oid;
  set oid(String? oid) => _oid = oid;

  Id.fromJson(Map<String, dynamic> json) {
    _oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this._oid;
    return data;
  }
}