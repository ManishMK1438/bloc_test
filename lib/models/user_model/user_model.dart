import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? phoneNumber;

  @HiveField(4)
  String? profilePic;

  @HiveField(5)
  String? gender;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.profilePic,
      this.gender});

  UserModel.fromJSON(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    email = map["email"];
    phoneNumber = map["PhoneNumber"];
    profilePic = map["profilePic"];
    gender = map["gender"];
  }
}
