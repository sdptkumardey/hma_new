class CircularApi {
  CircularApi({
    required this.circularNo,
    required this.circularDate,
    required this.description,
    required this.imgUrl,
  });

  final String circularNo;
  final String circularDate;
  final String description;
  final String imgUrl;

  factory CircularApi.fromJson(Map<String, dynamic> json) {
    return CircularApi(
      circularNo: json['circular_no'] ?? '',
      circularDate: json['circular_date'] ?? '',
      description: json['description'] ?? '',
      imgUrl: json['img_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circular_no': circularNo,
      'circular_date': circularDate,
      'description': description, // Reverts back to HTML if needed
      'img_url': imgUrl,
    };
  }
}
