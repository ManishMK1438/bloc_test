import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:equatable/equatable.dart';

enum PostStatus { loading, success, failure, empty }

//abstract class HomeState extends Equatable {}
/*

class LoadingHomeState extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
*/

class ValidHomeState extends Equatable {
  const ValidHomeState({
    this.status = PostStatus.loading,
    this.posts = const <PostModel>[],
    this.hasReachedMax = false,
    this.isLiked = false,
    this.error = "",
  });

  final PostStatus status;
  final List<PostModel> posts;
  final bool hasReachedMax;
  final bool isLiked;
  final String error;

  ValidHomeState copyWith({
    PostStatus? status,
    List<PostModel>? posts,
    String? error,
    bool? isLiked,
    bool? hasReachedMax,
  }) {
    return ValidHomeState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      error: error ?? this.error,
      isLiked: isLiked ?? this.isLiked,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}
/*


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
*/
