abstract class TabState {}

class InitialState extends TabState {}

class TabChangedState extends TabState {
  final int index;
  TabChangedState({required this.index});
}
