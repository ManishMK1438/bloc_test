import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostInteractionState extends Equatable {}

class InitialPostState extends PostInteractionState {
  @override
  List<Object?> get props => [];
}

class LikePostState extends PostInteractionState {
  final PostModel post;
  LikePostState({required this.post});

  LikePostState copyWith({
    PostModel? post,
  }) {
    return LikePostState(post: post ?? this.post);
  }

  @override
  List<Object?> get props => [post];

  @override
  String toString() {
    return '''totalLikes ${post.likes}, isLiked ${post.likedByMe}''';
  }
}

class SavePostState extends PostInteractionState {
  final PostModel post;
  SavePostState({required this.post});

  SavePostState copyWith({
    PostModel? post,
  }) {
    return SavePostState(post: post ?? this.post);
  }

  @override
  List<Object?> get props => [post];

  @override
  String toString() {
    return '''isSaved ${post.saved}''';
  }
}
