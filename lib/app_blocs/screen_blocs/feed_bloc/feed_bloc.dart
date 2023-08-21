import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/feed_bloc/feed_event.dart';
import 'package:bloc_test/app_blocs/screen_blocs/feed_bloc/feed_state.dart';
import 'package:bloc_test/models/feed_model/feed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/constants.dart';
import '../../../utils/strings.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  int querySize = 0;
  DocumentSnapshot<Map<String, dynamic>>? lastVisible;
  FeedBloc() : super(const FeedState()) {
    on<FeedEvent>((event, emit) => _fetchFeed(event, emit));
    add(const FeedEvent(isRefresh: false));
  }

  _fetchFeed(FeedEvent event, Emitter<FeedState> emit) async {
    if (event.isRefresh) {
      emit(const FeedState(status: FeedStatus.loading));
    }
    try {
      if (state.status == FeedStatus.loading) {
        final posts = await _fetchPosts();
        return emit(posts.isNotEmpty
            ? state.copyWith(
                status: FeedStatus.success,
                feed: posts,
                hasReachedMax: querySize < postLimit ? true : false,
              )
            : state.copyWith(status: FeedStatus.empty));
      }
      final posts = await _fetchMorePosts();
      emit(querySize <= postLimit && querySize != 0
          ? state.copyWith(
              status: FeedStatus.success,
              feed: List.of(state.feed)..addAll(posts),
              hasReachedMax: false,
            )
          : state.copyWith(hasReachedMax: true));
    } on FirebaseException catch (e, s) {
      debugPrintStack(stackTrace: s, label: "FeedBlocFirebaseError");
      emit(state.copyWith(
          status: FeedStatus.error, error: e.message.toString()));
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: "FeedBlocError");
      emit(state.copyWith(status: FeedStatus.error, error: e.toString()));
    }
  }

  Future<List<FeedModel>> _fetchPosts() async {
    var userCollection =
        await _fireStore.collection(AppStr.collectionUsers).get();
    var query = _fireStore
        .collection(AppStr.reelVideos)
        .limit(postLimit)
        .orderBy("postedOn", descending: true);

    var resp = await query.get();
    querySize = resp.docs.length;
    if (resp.docs.isNotEmpty) {
      lastVisible = resp.docs.last;
    }
    return _mergePostAndUserData(resp, userCollection);
  }

  List<FeedModel> _mergePostAndUserData(
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
    return post.map((e) => FeedModel.fromJson(e)).toList();
  }

  Future<List<FeedModel>> _fetchMorePosts() async {
    var userCollection =
        await _fireStore.collection(AppStr.collectionUsers).get();
    var query = _fireStore
        .collection(AppStr.reelVideos)
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
