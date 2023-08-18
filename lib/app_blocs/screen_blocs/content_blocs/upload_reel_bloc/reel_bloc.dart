import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/upload_reel_bloc/uplaod_reel_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/upload_reel_bloc/upload_reel_states.dart';
import 'package:bloc_test/local_storage/hive/hive_class.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadReelBloc extends Bloc<UploadReelEvent, UploadReelState> {
  final _uuid = const Uuid();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  UploadReelBloc() : super(const UploadReelState()) {
    on<ReelFieldEnteredEvent>((event, emit) => _fieldEntered(event, emit));
    on<ReelBtnPressedEvent>((event, emit) => _btnPressed(event, emit));
  }

  _fieldEntered(ReelFieldEnteredEvent event, Emitter<UploadReelState> emit) {
    if (event.desc.trim().isNotEmpty && event.video != null) {
      emit(state.copyWith(status: UploadReelStatus.valid));
    } else if (event.video != null) {
      emit(state.copyWith(status: UploadReelStatus.videoSelected));
    } else if (event.thumbnail != null) {
      emit(state.copyWith(status: UploadReelStatus.thumbnailSelected));
    } else {
      emit(state.copyWith(status: UploadReelStatus.initial));
    }
  }

  _btnPressed(ReelBtnPressedEvent event, Emitter<UploadReelState> emit) async {
    emit(state.copyWith(status: UploadReelStatus.loading));
    try {
      var hive = HiveClass().getBox(boxName: AppStr.userHiveBox);
      var userId = hive.getAt(0)?.id.toString();
      var videoId = _uuid.v1().toString();
      var thumbnailId = _uuid.v1().toString();
      final _ref =
          _storage.ref().child(AppStr.reelVideos).child(userId!).child(videoId);
      await _ref.putFile(event.video);
      final _url = await _ref.getDownloadURL();
      Uint8List? thumbnail;

      final _thumbnailRef = _storage
          .ref()
          .child(AppStr.reelVideos)
          .child(userId)
          .child(AppStr.thumbnailImages)
          .child(thumbnailId);

      if (event.thumbnail == null) {
        thumbnail = await VideoThumbnail.thumbnailData(
          video: event.video.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth:
              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );
        await _thumbnailRef.putData(thumbnail!);
      } else {
        await _thumbnailRef.putFile(event.thumbnail!);
      }

      final thumbnailUrl = await _thumbnailRef.getDownloadURL();

      String postId = _uuid.v4();
      Map<String, dynamic> map = {
        "reelId": postId,
        "userId": userId,
        "video": _url,
        "thumbnail": thumbnailUrl,
        "desc": event.desc,
        "likes": null,
        "comments": null,
        "saved": false,
        "likedByMe": false,
        "postedOn": DateTime.now().toString(),
      };
      await _fireStore.collection(AppStr.userPosts).doc(postId).set(map);
      emit(state.copyWith(status: UploadReelStatus.success));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status: UploadReelStatus.error, error: e.message.toString()));
    } catch (e) {
      emit(state.copyWith(status: UploadReelStatus.error, error: e.toString()));
    }
  }
}
