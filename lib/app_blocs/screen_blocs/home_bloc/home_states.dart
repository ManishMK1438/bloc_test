import 'package:bloc_test/models/post_model/post_model.dart';

abstract class HomeState {}

class LoadingHomeState extends HomeState {}

class ValidHomeState extends HomeState {
  List<PostModel> modelList;
  ValidHomeState({required this.modelList});
}

class NoDataHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String error;
  ErrorHomeState({required this.error});
}
