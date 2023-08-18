import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/post_interaction_bloc/interaction_state.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/post_interaction_bloc/post_interaction_event.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostInteractionBloc
    extends Bloc<PostInteractionEvent, PostInteractionState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  PostInteractionBloc() : super(const PostInteractionState()) {
    on<LikeIntBtnPressedEvent>((event, emit) => _likePressed(event, emit));
    on<SaveIntBtnPressedEvent>((event, emit) => _savePressed(event, emit));
  }

  _likePressed(
      LikeIntBtnPressedEvent event, Emitter<PostInteractionState> emit) async {
    try {
      final post = event.post;
      await _fireStore.collection(AppStr.userPosts).doc(post.postId).update({
        "likes": post.likedByMe! ? post.removeLikes() : post.updateLikes(),
        "likedByMe": post.liked()
      });
      /*.then((value) async {
        var userCollection =
            await _fireStore.collection(AppStr.collectionUsers).get();
        var map = userCollection.docs
            .firstWhere((element) => element.id == _functions.getUserId())
            .data();
        var updatedPost = await _fireStore
            .collection(AppStr.userPosts)
            .doc(post.postId)
            .withConverter<PostModel>(
              fromFirestore: (snapshot, _) =>
                  PostModel.fromJson(snapshot.data()!..addAll({"user": map})),
              toFirestore: (post, _) => post.toJson(),
            )
            .get();
        _modelList[event.index] = updatedPost.data()!;
      });*/
      if (post.likedByMe!) {
        emit(state.copyWith(post: post, status: InteractionsStatus.like));
      } else {
        emit(state.copyWith(post: post, status: InteractionsStatus.dislike));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: InteractionsStatus.error, error: e.message));
    } catch (e, s) {
      print(s);
      emit(state.copyWith(
          status: InteractionsStatus.error, error: e.toString()));
    }
  }

  _savePressed(
      SaveIntBtnPressedEvent event, Emitter<PostInteractionState> emit) async {
    try {
      final post = event.post;
      await _fireStore.collection(AppStr.userPosts).doc(post.postId).update({
        "saved": post.isSaved(),
      });
      if (post.saved!) {
        emit(state.copyWith(post: post, status: InteractionsStatus.save));
      } else {
        emit(state.copyWith(post: post, status: InteractionsStatus.unSave));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(status: InteractionsStatus.error, error: e.message));
    } catch (e, s) {
      print(s);
      emit(state.copyWith(
          status: InteractionsStatus.error, error: e.toString()));
    }
  }
}
