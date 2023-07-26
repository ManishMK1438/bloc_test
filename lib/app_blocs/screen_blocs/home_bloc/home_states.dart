import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:equatable/equatable.dart';

enum PostStatus { loading, success, failure }

abstract class HomeState extends Equatable {}

class LoadingHomeState extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ValidHomeState extends HomeState {
  final PostStatus status;
  final List<PostModel> modelList;

  ValidHomeState copyWith({
    PostStatus? status,
    List<PostModel>? posts,
  }) {
    return ValidHomeState(
      status: status ?? this.status,
      modelList: posts ?? modelList,
    );
  }

  ValidHomeState({
    required this.modelList,
    this.status = PostStatus.success,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [modelList, status];
}

class NoDataHomeState extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadMoreHomeState extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ErrorHomeState extends HomeState {
  final String error;
  ErrorHomeState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
