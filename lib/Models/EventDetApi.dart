/// img_url : "https://hmasiliguri.org/upload_image/gallery/sub/2025_02_10_04_45_56WhatsApp Image 2025-02-09 at 17.27.22_e28e62f4.jpg"

class EventDetApi {
  EventDetApi({
      String? imgUrl,}){
    _imgUrl = imgUrl;
}

  EventDetApi.fromJson(dynamic json) {
    _imgUrl = json['img_url'];
  }
  String? _imgUrl;
EventDetApi copyWith({  String? imgUrl,
}) => EventDetApi(  imgUrl: imgUrl ?? _imgUrl,
);
  String? get imgUrl => _imgUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['img_url'] = _imgUrl;
    return map;
  }

}