import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UploadReelEvent extends Equatable {}

class ReelFieldEnteredEvent extends UploadReelEvent {
  final String desc;
  final File? video;
  final File? thumbnail;
  ReelFieldEnteredEvent(
      {required this.desc, required this.video, this.thumbnail});

  @override
  // TODO: implement props
  List<Object?> get props => [desc, video, thumbnail];

  @override
  String toString() {
    // TODO: implement toString
    return '''ReelFieldEnteredEvent { desc: $desc, video: ${video?.path}, thumbnail: ${thumbnail?.path}''';
  }
}

class ReelBtnPressedEvent extends UploadReelEvent {
  final String desc;
  final File video;
  final File? thumbnail;
  ReelBtnPressedEvent(
      {required this.desc, required this.video, this.thumbnail});

  @override
  // TODO: implement props
  List<Object?> get props => [desc, video, thumbnail];

  @override
  String toString() {
    // TODO: implement toString
    return '''ReelFieldEnteredEvent { desc: $desc, video: ${video.path}, thumbnail: ${thumbnail?.path}''';
  }
}
