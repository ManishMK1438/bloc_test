import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class LoadInitialDataHomeEvent extends HomeEvent {
  final bool refresh;
  LoadInitialDataHomeEvent({required this.refresh});
  @override
  // TODO: implement props
  List<Object?> get props => [refresh];
}

class LikedHomeEvent extends HomeEvent {
  final PostModel post;
  final int index;
  LikedHomeEvent({required this.post, required this.index});
  @override
  // TODO: implement props
  List<Object?> get props => [post, index];
}

class SavedHomeEvent extends HomeEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
