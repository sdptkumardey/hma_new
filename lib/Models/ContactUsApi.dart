/// post_name : "President"
/// name : "Sri Bijay Kr. Agarwal"
/// store : "M/s. Beharilall Madanlall"
/// address : "Sevoke Road, Siliguri"
/// phone : ""
/// email : ""
/// mobile : "94344 64696 (M)"
/// img_url : "https://hmasiliguri.org/upload_image/member/2023_07_04_16_44_21_2018_08_13_10_15_40_2016_03_17_08_05_22_1.jpg"

class ContactUsApi {
  ContactUsApi({
      String? postName, 
      String? name, 
      String? store, 
      String? address, 
      String? phone, 
      String? email, 
      String? mobile, 
      String? imgUrl,}){
    _postName = postName;
    _name = name;
    _store = store;
    _address = address;
    _phone = phone;
    _email = email;
    _mobile = mobile;
    _imgUrl = imgUrl;
}

  ContactUsApi.fromJson(dynamic json) {
    _postName = json['post_name'];
    _name = json['name'];
    _store = json['store'];
    _address = json['address'];
    _phone = json['phone'];
    _email = json['email'];
    _mobile = json['mobile'];
    _imgUrl = json['img_url'];
  }
  String? _postName;
  String? _name;
  String? _store;
  String? _address;
  String? _phone;
  String? _email;
  String? _mobile;
  String? _imgUrl;
ContactUsApi copyWith({  String? postName,
  String? name,
  String? store,
  String? address,
  String? phone,
  String? email,
  String? mobile,
  String? imgUrl,
}) => ContactUsApi(  postName: postName ?? _postName,
  name: name ?? _name,
  store: store ?? _store,
  address: address ?? _address,
  phone: phone ?? _phone,
  email: email ?? _email,
  mobile: mobile ?? _mobile,
  imgUrl: imgUrl ?? _imgUrl,
);
  String? get postName => _postName;
  String? get name => _name;
  String? get store => _store;
  String? get address => _address;
  String? get phone => _phone;
  String? get email => _email;
  String? get mobile => _mobile;
  String? get imgUrl => _imgUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_name'] = _postName;
    map['name'] = _name;
    map['store'] = _store;
    map['address'] = _address;
    map['phone'] = _phone;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['img_url'] = _imgUrl;
    return map;
  }

}