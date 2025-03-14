import 'dart:convert';

class PhoneBook {
  String category;
  bool show;
  String disImg;
  List<PhoneBookDetail> phoneBookDetails;

  PhoneBook({
    required this.category,
    required this.show,
    required this.disImg,
    required this.phoneBookDetails,
  });

  factory PhoneBook.fromJson(Map<String, dynamic> json) {
    return PhoneBook(
      category: json['category'],
      show: json['show'],
      disImg: json['dis_img'],
      phoneBookDetails: (json['phone_book_det'] as List)
          .map((item) => PhoneBookDetail.fromJson(item))
          .toList(),
    );
  }

  static List<PhoneBook> fromJsonList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((json) => PhoneBook.fromJson(json)).toList();
  }
}

class PhoneBookDetail {
  String subject;
  List<PhoneNumber> phoneNumbers;

  PhoneBookDetail({
    required this.subject,
    required this.phoneNumbers,
  });

  factory PhoneBookDetail.fromJson(Map<String, dynamic> json) {
    return PhoneBookDetail(
      subject: json['subject'],
      phoneNumbers: (json['ph'] as List)
          .map((item) => PhoneNumber.fromJson(item))
          .toList(),
    );
  }
}

class PhoneNumber {
  String phone;

  PhoneNumber({required this.phone});

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(phone: json['phone']);
  }
}
