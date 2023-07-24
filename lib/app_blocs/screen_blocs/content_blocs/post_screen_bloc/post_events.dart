import 'dart:io';

abstract class PostEvent {}

class PostFieldEnteredEvent extends PostEvent {
  final String postDesc;
  final File? img;
  PostFieldEnteredEvent({required this.postDesc, required this.img});
}

class PostBtnPressedEvent extends PostEvent {
  final File? img;
  final String postDesc;
  PostBtnPressedEvent({required this.img, required this.postDesc});
}
