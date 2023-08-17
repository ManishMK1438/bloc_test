import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:equatable/equatable.dart';

enum InteractionsStatus { initial, like, dislike, save, unSave, error }

class PostInteractionState extends Equatable {
  final PostModel? post;
  final InteractionsStatus status;
  final String error;
  const PostInteractionState({
    this.post,
    this.status = InteractionsStatus.initial,
    this.error = "",
  });

  PostInteractionState copyWith({
    PostModel? post,
    InteractionsStatus? status,
    String? error,
  }) {
    return PostInteractionState(
      post: post ?? this.post,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [post, status, error];

  @override
  String toString() {
    // TODO: implement toString
    return '''PostInteractionState { post: ${post.toString()}, status: $status, error: $error}''';
  }
}
