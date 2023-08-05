import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject with EquatableMixin {
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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['profilePic'] = this.profilePic;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber, profilePic, gender, name, id, email];
}
