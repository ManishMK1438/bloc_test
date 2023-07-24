abstract class PostState {}

class PostInitialState extends PostState {}

class PostValidState extends PostState {}

class PostImgSelectedState extends PostState {}

class PostLoadingState extends PostState {}

class PostSuccessState extends PostState {}

class PostErrorState extends PostState {
  final String error;
  PostErrorState({required this.error});
}
