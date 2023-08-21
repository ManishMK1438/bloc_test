import 'package:equatable/equatable.dart';

class FeedEvent extends Equatable {
  final bool isRefresh;
  const FeedEvent({required this.isRefresh});
  @override
  // TODO: implement props
  List<Object?> get props => [isRefresh];
}
