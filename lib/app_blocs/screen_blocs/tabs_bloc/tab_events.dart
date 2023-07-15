abstract class TabEvent {}

class TabIndexChangedEvent extends TabEvent {
  int index = 0;
  TabIndexChangedEvent({required this.index});
}
