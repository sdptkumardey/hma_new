/// id : "53"
/// p_year : "2024-25"
/// p_president : "Sri Bijay Kr. Agarwal"
/// p_sec : "Sri Bimal Agarwal"
/// p_trea : "Sri Kailash Agarwal"

class RollOfHonourApi {
  RollOfHonourApi({
      String? id, 
      String? pYear, 
      String? pPresident, 
      String? pSec, 
      String? pTrea,}){
    _id = id;
    _pYear = pYear;
    _pPresident = pPresident;
    _pSec = pSec;
    _pTrea = pTrea;
}

  RollOfHonourApi.fromJson(dynamic json) {
    _id = json['id'];
    _pYear = json['p_year'];
    _pPresident = json['p_president'];
    _pSec = json['p_sec'];
    _pTrea = json['p_trea'];
  }
  String? _id;
  String? _pYear;
  String? _pPresident;
  String? _pSec;
  String? _pTrea;
RollOfHonourApi copyWith({  String? id,
  String? pYear,
  String? pPresident,
  String? pSec,
  String? pTrea,
}) => RollOfHonourApi(  id: id ?? _id,
  pYear: pYear ?? _pYear,
  pPresident: pPresident ?? _pPresident,
  pSec: pSec ?? _pSec,
  pTrea: pTrea ?? _pTrea,
);
  String? get id => _id;
  String? get pYear => _pYear;
  String? get pPresident => _pPresident;
  String? get pSec => _pSec;
  String? get pTrea => _pTrea;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['p_year'] = _pYear;
    map['p_president'] = _pPresident;
    map['p_sec'] = _pSec;
    map['p_trea'] = _pTrea;
    return map;
  }

}