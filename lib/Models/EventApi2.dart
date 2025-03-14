/// album : "63"
/// album_name : "Pujya Dr. Gyanvatsal Swami"
/// album_image : "https://hmasiliguri.org/upload_image/gallery/main/2025_02_10_04_45_35_WhatsApp Image 2025-02-09 at 17.27.22_e28e62f4.jpg"
/// img : "2025_02_10_04_45_35_WhatsApp Image 2025-02-09 at 17.27.22_e28e62f4.jpg"
/// num_image : "11"

class EventApi2 {
  EventApi2({
      String? album, 
      String? albumName, 
      String? albumImage, 
      String? img, 
      String? numImage,}){
    _album = album;
    _albumName = albumName;
    _albumImage = albumImage;
    _img = img;
    _numImage = numImage;
}

  EventApi2.fromJson(dynamic json) {
    _album = json['album'];
    _albumName = json['album_name'];
    _albumImage = json['album_image'];
    _img = json['img'];
    _numImage = json['num_image'];
  }
  String? _album;
  String? _albumName;
  String? _albumImage;
  String? _img;
  String? _numImage;
EventApi2 copyWith({  String? album,
  String? albumName,
  String? albumImage,
  String? img,
  String? numImage,
}) => EventApi2(  album: album ?? _album,
  albumName: albumName ?? _albumName,
  albumImage: albumImage ?? _albumImage,
  img: img ?? _img,
  numImage: numImage ?? _numImage,
);
  String? get album => _album;
  String? get albumName => _albumName;
  String? get albumImage => _albumImage;
  String? get img => _img;
  String? get numImage => _numImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['album'] = _album;
    map['album_name'] = _albumName;
    map['album_image'] = _albumImage;
    map['img'] = _img;
    map['num_image'] = _numImage;
    return map;
  }

}