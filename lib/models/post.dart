// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String usermage;
  final String uid;
  final String description;
  final String postId;
  final dataPublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.usermage,
    required this.uid,
    required this.description,
    required this.postId,
    required this.dataPublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "username": usermage,
        "uid": uid,
        "description": description,
        "postId": postId,
        "dataPublished": dataPublished,
        "postUrl": postUrl,
        "profImage": profImage,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      usermage: snapshot['usermage'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      dataPublished: snapshot['dataPublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
