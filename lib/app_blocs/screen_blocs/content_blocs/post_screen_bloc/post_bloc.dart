import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/post_screen_bloc/post_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/post_screen_bloc/post_states.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../../local_storage/hive/hive_class.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final _uuid = const Uuid();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  PostBloc() : super(PostInitialState()) {
    on<PostFieldEnteredEvent>((event, emit) => _fieldEntered(event, emit));

    on<PostBtnPressedEvent>((event, emit) => _btnPressed(event, emit));
  }

  _fieldEntered(PostFieldEnteredEvent event, Emitter<PostState> emit) {
    if (event.postDesc.trim().isNotEmpty && event.img != null) {
      emit(PostValidState());
    } else if (event.img != null) {
      emit(PostImgSelectedState());
    } else {
      emit(PostInitialState());
    }
  }

  _btnPressed(PostBtnPressedEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());
    try {
      var hive = HiveClass().getBox(boxName: AppStr.userHiveBox);
      var userId = hive.getAt(0)?.id.toString();
      final _ref = _storage
          .ref()
          .child(AppStr.postImages)
          .child(userId!)
          .child(_uuid.v1().toString());
      await _ref.putFile(event.img!);
      final _url = await _ref.getDownloadURL();

      Map<String, dynamic> map = {
        "postId": _uuid.v4(),
        "userId": userId,
        "image": _url,
        "desc": event.postDesc,
        "likes": null,
        "comments": null,
        "saved": false,
        "likedByMe": false
      };
      await _fireStore.collection(AppStr.userPosts).doc(userId).set(map);
      emit(PostSuccessState());
    } on FirebaseException catch (e) {
      emit(PostErrorState(error: e.message.toString()));
    } catch (e) {
      emit(PostErrorState(error: e.toString()));
    }
  }
}
