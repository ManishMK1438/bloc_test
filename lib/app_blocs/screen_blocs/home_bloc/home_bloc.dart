import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_states.dart';
import 'package:bloc_test/app_functions/app_functions.dart';
import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _functions = AppFunctions();
  List<PostModel> _modelList = [];
  HomeBloc() : super(LoadingHomeState()) {
    on<LoadInitialDataHomeState>(
        (event, emit) => _loadInitialData(event, emit));
    on<LoadMoreHomeEvent>((event, emit) => _loadMore(event, emit));
    on<LikedHomeEvent>((event, emit) => _liked(event, emit));
    on<SavedHomeEvent>((event, emit) => _saved(event, emit));
    //_loadInitialData();
    add(LoadInitialDataHomeState());
  }

  _loadInitialData(
      LoadInitialDataHomeState event, Emitter<HomeState> emit) async {
    try {
      //Get post details
      var userData = {};
      List<Map<String, dynamic>> post = [];
      var userCollection =
          await _fireStore.collection(AppStr.collectionUsers).get();
      var data = await _fireStore.collection(AppStr.userPosts).get();
      for (var e in data.docs) {
        userData = userCollection.docs
            .firstWhere((element) => element.id == e.data()['userId'])
            .data();
        post.add(e.data()..addAll({"user": userData}));
      }

      for (var v in post) {
        _modelList.add(PostModel.fromJson(v));
      }

      emit(ValidHomeState(modelList: _modelList));
    } on FirebaseException catch (e) {
      emit(ErrorHomeState(error: e.message.toString()));
    } catch (e) {
      emit(ErrorHomeState(error: e.toString()));
    }
  }

  _loadMore(LoadMoreHomeEvent event, Emitter<HomeState> emit) {}

  _liked(LikedHomeEvent event, Emitter<HomeState> emit) {}

  _saved(SavedHomeEvent event, Emitter<HomeState> emit) {}
}
