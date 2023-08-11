import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_states.dart';
import 'package:bloc_test/app_functions/app_functions.dart';
import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeBloc extends Bloc<HomeEvent, ValidHomeState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final _functions = AppFunctions();
  List<PostModel> _modelList = [];
  int querySize = 0;
  QueryDocumentSnapshot<Map<String, dynamic>>? lastVisible;
  HomeBloc() : super(const ValidHomeState()) {
    on<LoadInitialDataHomeEvent>(
        (event, emit) => _loadInitialData(event, emit));
    on<LikedHomeEvent>((event, emit) => _liked(event, emit));
    on<SavedHomeEvent>((event, emit) => _saved(event, emit));
    //_loadInitialData();
    add(LoadInitialDataHomeEvent(refresh: false));
  }

  _loadInitialData(
      LoadInitialDataHomeEvent event, Emitter<ValidHomeState> emit) async {
    try {
      var userData = {};
      List<Map<String, dynamic>> post = [];
      if (event.refresh) {
        _modelList.clear();
        userData.clear();
        post.clear();
        emit(const ValidHomeState(status: PostStatus.loading));
      }

      //collections
      var userCollection =
          await _fireStore.collection(AppStr.collectionUsers).get();
      var query = _fireStore
          .collection(AppStr.userPosts)
          .limit(postLimit)
          .orderBy("postedOn", descending: true);

      //filtering and merging
      if (state.status == PostStatus.loading) {
        await query.get().then((value) {
          querySize = value.size;
          if (querySize == 0) {
            emit(state.copyWith(status: PostStatus.empty, hasReachedMax: true));
          } else {
            lastVisible = value.docs[value.size - 1];
            for (var e in value.docs) {
              userData = userCollection.docs
                  .firstWhere((element) => element.id == e.data()['userId'])
                  .data();
              post.add(e.data()..addAll({"user": userData}));
            }
            for (var v in post) {
              _modelList.add(PostModel.fromJson(v));
            }
            emit(state.copyWith(
                posts: _modelList,
                hasReachedMax: querySize >= postLimit ? false : true,
                status: PostStatus.success));
          }
        });
      } else {
        if (querySize == postLimit) {
          //post.clear();
          //_modelList.clear();
          await query.startAfterDocument(lastVisible!).get().then((value) {
            querySize = value.size;
            print(querySize);
            lastVisible = value.docs[value.size - 1];
            //print(value.docs[value.size - 1].data());
            for (var e in value.docs) {
              userData = userCollection.docs
                  .firstWhere((element) => element.id == e.data()['userId'])
                  .data();
              post.add(e.data()..addAll({"user": userData}));
            }
            // print("post length ${post.length}");
            for (var v in post) {
              _modelList.add(PostModel.fromJson(v));
            }
          });
          // print("${List.of(state.posts).length} list length");
          emit(state.copyWith(
              posts: List.of(state.posts)..addAll(_modelList),
              hasReachedMax: false,
              status: PostStatus.success));
          //_modelList.clear();
          post.clear();
        } else {
          emit(state.copyWith(
            posts: _modelList,
            status: PostStatus.success,
            hasReachedMax: true,
          ));
        }
      }
      //Get post details
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status: PostStatus.failure, error: e.message.toString()));
    } catch (e) {
      emit(state.copyWith(status: PostStatus.failure, error: e.toString()));
    }
  }

  _liked(LikedHomeEvent event, Emitter<ValidHomeState> emit) async {
    try {
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
    }
  }

  _saved(SavedHomeEvent event, Emitter<ValidHomeState> emit) {}
}
