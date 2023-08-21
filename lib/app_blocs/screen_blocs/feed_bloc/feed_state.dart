import 'package:equatable/equatable.dart';

import '../../../models/feed_model/feed_model.dart';

enum FeedStatus { loading, success, error, empty }

class FeedState extends Equatable {
  final String error;
  final FeedStatus status;
  final bool hasReachedMax;
  final List<FeedModel> feed;
  const FeedState(
      {this.error = "",
      this.hasReachedMax = false,
      this.feed = const <FeedModel>[],
      this.status = FeedStatus.loading});

  FeedState copyWith(
      {FeedStatus? status,
      bool? hasReachedMax,
      List<FeedModel>? feed,
      String? error}) {
    return FeedState(
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        feed: feed ?? this.feed,
        status: status ?? this.status);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [error, hasReachedMax, feed, status];

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, feedLength: ${feed.length} }''';
  }
}
