import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/connectivity_blocs/internet_events.dart';
import 'package:bloc_test/app_blocs/connectivity_blocs/internet_states.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState>{
  final Connectivity _connectivity = Connectivity();
  InternetBloc() : super(InternetInitialState()){
    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    _checkConnection();
  }

  _checkConnection(){
    _connectivity.onConnectivityChanged.listen((event) {
      if(event == ConnectivityResult.mobile || event == ConnectivityResult.wifi){
        add(InternetGainedEvent());
      }else{
        add(InternetLostEvent());
      }
    });
  }
}