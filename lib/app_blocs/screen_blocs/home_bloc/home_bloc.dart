import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_states.dart';
import 'package:bloc_test/app_functions/app_functions.dart';
import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final _functions = AppFunctions();
  List<PostModel> _modelList = [];
  int querySize = 0;
  QueryDocumentSnapshot<Map<String, dynamic>>? lastVisible;
  HomeBloc() : super(LoadingHomeState()) {
    on<LoadInitialDataHomeEvent>(
        (event, emit) => _loadInitialData(event, emit));
    on<LoadMoreHomeEvent>((event, emit) => _loadMore(event, emit));
    on<LikedHomeEvent>((event, emit) => _liked(event, emit));
    on<SavedHomeEvent>((event, emit) => _saved(event, emit));
    //_loadInitialData();
    add(LoadInitialDataHomeEvent(refresh: false));
  }

  _loadInitialData(
      LoadInitialDataHomeEvent event, Emitter<HomeState> emit) async {
    try {
      if (event.refresh) {
        emit(LoadingHomeState());
      }
      //Get post details
      _modelList.clear();
      querySize = 0;
      lastVisible = null;
      var userData = {};
      List<Map<String, dynamic>> post = [];
      var userCollection =
          await _fireStore.collection(AppStr.collectionUsers).get();
      await _fireStore
          .collection(AppStr.userPosts)
          .limit(postLimit)
          .orderBy("postedOn", descending: true)
          .get()
          .then((value) {
        querySize = value.size;
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
      });
      // print(_modelList.length);
      emit(ValidHomeState(modelList: _modelList).copyWith(
        status:
            querySize >= postLimit ? PostStatus.success : PostStatus.failure,
      ));
    } on FirebaseException catch (e) {
      emit(ErrorHomeState(error: e.message.toString()));
    } catch (e) {
      emit(ErrorHomeState(error: e.toString()));
    }
  }

  _loadMore(LoadMoreHomeEvent event, Emitter<HomeState> emit) async {
    emit(ValidHomeState(modelList: const [])
        .copyWith(status: PostStatus.loading, posts: _modelList));
    try {
      if (querySize >= postLimit) {
        //Get post details
        var userData = {};
        List<Map<String, dynamic>> post = [];
        var userCollection =
            await _fireStore.collection(AppStr.collectionUsers).get();
        await _fireStore
            .collection(AppStr.userPosts)
            .limit(postLimit)
            .orderBy("postedOn", descending: true)
            .startAfterDocument(lastVisible!)
            .get()
            .then((value) {
          querySize = value.size;
          lastVisible = value.docs[value.size - 1];
          print(value.docs[value.size - 1].data());
          for (var e in value.docs) {
            userData = userCollection.docs
                .firstWhere((element) => element.id == e.data()['userId'])
                .data();
            post.add(e.data()..addAll({"user": userData}));
          }
          for (var v in post) {
            _modelList.add(PostModel.fromJson(v));
          }
        });
        print("${_modelList.length} list length");
        emit(ValidHomeState(modelList: _modelList.toSet().toList()).copyWith(
          status: PostStatus.success,
        ));
      } else {
        emit(ValidHomeState(modelList: _modelList.toSet().toList()).copyWith(
          status: PostStatus.failure,
        ));
      }
    } on FirebaseException catch (e) {
      print(e.message.toString());
      emit(ErrorHomeState(error: e.message.toString()));
    } catch (e) {
      print(e.toString());
      emit(ErrorHomeState(error: e.toString()));
    }
  }

  _liked(LikedHomeEvent event, Emitter<HomeState> emit) async {
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
      emit(ValidHomeState(modelList: _modelList.toSet().toList()).copyWith());
    } on FirebaseException catch (e) {
      emit(ErrorHomeState(error: e.message.toString()));
    } catch (e, s) {
      print(s);
      emit(ErrorHomeState(error: e.toString()));
    }
  }

  _saved(SavedHomeEvent event, Emitter<HomeState> emit) {}
}
