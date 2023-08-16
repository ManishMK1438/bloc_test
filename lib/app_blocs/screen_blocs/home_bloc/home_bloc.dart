import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_states.dart';
import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeBloc extends Bloc<HomeEvent, ValidHomeState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  int querySize = 0;
  DocumentSnapshot<Map<String, dynamic>>? lastVisible;
  HomeBloc() : super(const ValidHomeState()) {
    on<LoadInitialDataHomeEvent>((event, emit) => _onPostFetched(event, emit));
    add(LoadInitialDataHomeEvent(refresh: false));
  }

  Future<void> _onPostFetched(
      LoadInitialDataHomeEvent event, Emitter<ValidHomeState> emit) async {
    if (event.refresh) {
      emit(const ValidHomeState(status: PostStatus.loading));
    }
    try {
      if (state.status == PostStatus.loading) {
        final posts = await _fetchPosts();
        return emit(posts.isNotEmpty
            ? state.copyWith(
                status: PostStatus.success,
                posts: posts,
                hasReachedMax: querySize < postLimit ? true : false,
              )
            : state.copyWith(status: PostStatus.empty));
      }
      final posts = await _fetchMorePosts();
      emit(querySize <= postLimit && querySize != 0
          ? state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
            )
          : state.copyWith(hasReachedMax: true));
    } on FirebaseException catch (e, s) {
      debugPrintStack(stackTrace: s, label: "Firebase");
      emit(state.copyWith(
          status: PostStatus.failure, error: e.message.toString()));
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(status: PostStatus.failure, error: e.toString()));
    }
  }

  Future<List<PostModel>> _fetchPosts() async {
    var userCollection =
        await _fireStore.collection(AppStr.collectionUsers).get();
    var query = _fireStore
        .collection(AppStr.userPosts)
        .limit(postLimit)
        .orderBy("postedOn", descending: true);

    var resp = await query.get();
    querySize = resp.docs.length;
    if (resp.docs.isNotEmpty) {
      lastVisible = resp.docs.last;
    }
    return _mergePostAndUserData(resp, userCollection);
  }

  List<PostModel> _mergePostAndUserData(
      QuerySnapshot<Map<String, dynamic>> resp,
      QuerySnapshot<Map<String, dynamic>> userCollection) {
    var userData = {};
    List<Map<String, dynamic>> post = [];
    for (var e in resp.docs) {
      userData = userCollection.docs
          .firstWhere((element) => element.id == e.data()['userId'])
          .data();
      post.add(e.data()..addAll({"user": userData}));
    }
    return post.map((e) => PostModel.fromJson(e)).toList();
  }

  Future<List<PostModel>> _fetchMorePosts() async {
    var userCollection =
        await _fireStore.collection(AppStr.collectionUsers).get();
    var query = _fireStore
        .collection(AppStr.userPosts)
        .limit(postLimit)
        .orderBy("postedOn", descending: true);
    // print(lastVisible!.data());
    var resp = await query.startAfterDocument(lastVisible!).get();
    querySize = resp.docs.length;
    // print(querySize);
    if (resp.docs.isNotEmpty) {
      lastVisible = resp.docs.last;
    }
    return _mergePostAndUserData(resp, userCollection);
  }
}
