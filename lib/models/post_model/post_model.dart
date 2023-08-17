import 'dart:math';

import 'package:equatable/equatable.dart';

import '../user_model/user_model.dart';

class PostModel extends Equatable {
  String? image;
  int? comments;
  bool? likedByMe;
  bool? saved;
  String? postedOn;
  String? postId;
  String? userId;
  String? desc;
  int? likes;
  UserModel? user;

  PostModel(
      {this.image,
      this.comments,
      this.likedByMe,
      this.saved,
      this.postedOn,
      this.postId,
      this.userId,
      this.desc,
      this.likes,
      this.user});

  int? updateLikes() {
    if (likes == null) {
      return likes = 1;
    } else {
      return likes = likes! + 1;
    }
  }

  int? removeLikes() {
    if (likes != null) {
      likes = max(0, likes! - 1);
    } else {
      likes = null;
    }
    return likes;
  }

  bool liked() {
    likedByMe = !likedByMe!;
    return likedByMe!;
  }

  bool isSaved() {
    saved = !saved!;
    return saved!;
  }

  PostModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    comments = json['comments'];
    likedByMe = json['likedByMe'];
    saved = json['saved'];
    postedOn = json['postedOn'];
    postId = json['postId'];
    userId = json['userId'];
    desc = json['desc'];
    likes = json['likes'];
    user = json['user'] != null ? UserModel.fromJSON(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['comments'] = this.comments;
    data['likedByMe'] = this.likedByMe;
    data['saved'] = this.saved;
    data['postedOn'] = this.postedOn;
    data['postId'] = this.postId;
    data['userId'] = this.userId;
    data['desc'] = this.desc;
    data['likes'] = this.likes;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        image,
        comments,
        likes,
        likedByMe,
        saved,
        postId,
        postedOn,
        userId,
        desc,
        user
      ];

  @override
  String toString() {
    // TODO: implement toString
    return '''PostModel {likes: $likes, likeByMe: $likedByMe, save: $saved}''';
  }
}
