import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostInteractionEvent extends Equatable {}

class LikeIntBtnPressedEvent extends PostInteractionEvent {
  final PostModel post;
  LikeIntBtnPressedEvent({required this.post});

  LikeIntBtnPressedEvent copyWith({PostModel? post}) {
    return LikeIntBtnPressedEvent(post: post ?? this.post);
  }

  @override
  List<Object?> get props => [post];

  @override
  String toString() {
    return '''totalLikes ${post.likes}, isLiked ${post.likedByMe}''';
  }
}

class SaveIntBtnPressedEvent extends PostInteractionEvent {
  final PostModel post;
  SaveIntBtnPressedEvent({required this.post});

  SaveIntBtnPressedEvent copyWith({PostModel? post}) {
    return SaveIntBtnPressedEvent(post: post ?? this.post);
  }

  @override
  List<Object?> get props => [post];

  @override
  String toString() {
    return '''isSaved ${post.saved}''';
  }
}
