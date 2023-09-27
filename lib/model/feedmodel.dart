import 'package:cloud_firestore/cloud_firestore.dart';

class FeedModel {
  final String uid;
  final String albumName;
  final String docId;
  final String image;
  final String path;
  final Timestamp dateTime;
  final bool thumbnail;

  const FeedModel({
    required this.uid,
    required this.albumName,
    required this.docId,
    required this.image,
    required this.path,
    required this.dateTime,
    required this.thumbnail,
  });
  
  factory FeedModel.fromFirestore(Map<String, dynamic> json) {
    return FeedModel(
      uid: json["uid"],
      docId: json["docId"],
      image: json["image"],
      path: json["path"],
      dateTime: json["dateTime"],
      albumName: json['albumName'],
      thumbnail: json['thumbnail']
    );
  }
  Map<String, dynamic> toFirestore() => {
        "uid": uid,
        "docId": docId,
        "image": image,
        "path": path,
        "dateTime": dateTime,
        'albumName': albumName,
        'thumbnail' : thumbnail
      };
}