import 'package:bloc/blocs.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/post_interaction_bloc/interaction_state.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/post_interaction_bloc/post_interaction_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app_functions/app_functions.dart';

class PostInteractionBloc
    extends Bloc<PostInteractionEvent, PostInteractionState> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final _functions = AppFunctions();
  PostInteractionBloc() : super(InitialPostState()) {
    on<LikeIntBtnPressedEvent>((event, emit) => _likePressed(event, emit));
    on<SaveIntBtnPressedEvent>((event, emit) => _savePressed(event, emit));
  }

  _likePressed(
      LikeIntBtnPressedEvent event, Emitter<PostInteractionState> emit) {
    /*try {
      final post = event.post;
      await _fireStore.collection(AppStr.userPosts).doc(post.postId).update({
        "likes": post.likedByMe! ? post.removeLikes() : post.updateLikes(),
        "likedByMe": post.liked(post.likedByMe!)
      }).then((value) async {
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
      });
      emit(const ValidHomeState().copyWith(
          isLiked: event.like, status: PostStatus.success, posts: _modelList));
    } on FirebaseException catch (e) {
      emit(const ValidHomeState().copyWith(status: PostStatus.failure));
    } catch (e, s) {
      print(s);
      emit(const ValidHomeState().copyWith(status: PostStatus.failure));
    }*/
  }
  _savePressed(
      SaveIntBtnPressedEvent event, Emitter<PostInteractionState> emit) {}
}
