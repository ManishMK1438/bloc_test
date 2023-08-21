import 'package:equatable/equatable.dart';

import '../user_model/user_model.dart';

class FeedModel extends Equatable {
  int? comments;
  String? desc;
  bool? likedByMe;
  int? likes;
  String? postedOn;
  String? reelId;
  bool? saved;
  String? thumbnail;
  String? userId;
  String? video;
  UserModel? user;

  FeedModel(
      {this.comments,
      this.desc,
      this.likedByMe,
      this.likes,
      this.postedOn,
      this.reelId,
      this.saved,
      this.thumbnail,
      this.userId,
      this.video,
      this.user});

  FeedModel.fromJson(Map<String, dynamic> json) {
    comments = json['comments'];
    desc = json['desc'];
    likedByMe = json['likedByMe'];
    likes = json['likes'];
    postedOn = json['postedOn'];
    reelId = json['reelId'];
    saved = json['saved'];
    thumbnail = json['thumbnail'];
    userId = json['userId'];
    video = json['video'];
    user = json['user'] != null ? UserModel.fromJSON(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comments'] = this.comments;
    data['desc'] = this.desc;
    data['likedByMe'] = this.likedByMe;
    data['likes'] = this.likes;
    data['postedOn'] = this.postedOn;
    data['reelId'] = this.reelId;
    data['saved'] = this.saved;
    data['thumbnail'] = this.thumbnail;
    data['userId'] = this.userId;
    data['video'] = this.video;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        comments,
        desc,
        likedByMe,
        likes,
        postedOn,
        reelId,
        saved,
        thumbnail,
        user,
        video,
        user
      ];
}
