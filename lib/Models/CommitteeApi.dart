class CommitteeApi {
  List<Member> executiveCommittee;
  List<Member> executiveSubCommittee;

  CommitteeApi({required this.executiveCommittee, required this.executiveSubCommittee});

  factory CommitteeApi.fromJson(Map<String, dynamic> json) {
    var list1 = json['executive_committee'] as List;
    List<Member> executiveCommitteeList = list1.map((i) => Member.fromJson(i)).toList();

    var list2 = json['executive_sub_committee'] as List;
    List<Member> executiveSubCommitteeList = list2.map((i) => Member.fromJson(i)).toList();

    return CommitteeApi(
      executiveCommittee: executiveCommitteeList,
      executiveSubCommittee: executiveSubCommitteeList,
    );
  }
}

class Member {
  String postName;
  String name;
  String store;
  String address;
  String phone;
  String email;
  String mobile;
  String imgUrl;

  Member({
    required this.postName,
    required this.name,
    required this.store,
    required this.address,
    required this.phone,
    required this.email,
    required this.mobile,
    required this.imgUrl,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      postName: json['post_name'] as String,
      name: json['name'] as String,
      store: json['store'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      imgUrl: json['img_url'] as String,
    );
  }
}
