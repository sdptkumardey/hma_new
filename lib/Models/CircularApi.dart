class Circular {
  final String circularNo;
  final String circularDate;
  final String description;
  final String imgUrl;

  Circular({
    required this.circularNo,
    required this.circularDate,
    required this.description,
    required this.imgUrl,
  });

  factory Circular.fromJson(Map<String, dynamic> json) {
    return Circular(
      circularNo: json['circular_no'],
      circularDate: json['circular_date'],
      description: json['description'],
      imgUrl: json['img_url'],
    );
  }
}
