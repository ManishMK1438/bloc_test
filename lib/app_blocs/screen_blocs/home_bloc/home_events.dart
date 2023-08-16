import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class LoadInitialDataHomeEvent extends HomeEvent {
  final bool refresh;
  LoadInitialDataHomeEvent({required this.refresh});
  @override
  // TODO: implement props
  List<Object?> get props => [refresh];
}
/*
class LikedHomeEvent extends HomeEvent {
  final PostModel post;
  final int index;
  final bool like;
  LikedHomeEvent({required this.post, required this.index, required this.like});
  @override
  // TODO: implement props
  List<Object?> get props => [post, index, like];
}

class SavedHomeEvent extends HomeEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}*/
