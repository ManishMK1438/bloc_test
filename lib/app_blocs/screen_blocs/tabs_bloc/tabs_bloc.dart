import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/tabs_bloc/tab_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/tabs_bloc/tab_state.dart';

class TabsBloc extends Bloc<TabEvent, TabState> {
  TabsBloc() : super(InitialState()) {
    on<TabIndexChangedEvent>(
        (event, emit) => emit(TabChangedState(index: event.index)));
  }
}
