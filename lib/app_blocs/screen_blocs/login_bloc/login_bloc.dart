import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/login_bloc/login_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/login_bloc/login_states.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../local_storage/hive/hive_class.dart';
import '../../../models/user_model/user_model.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  LoginBloc() : super(LoginInitialState()) {
    on<LoginFieldsEnteredEvent>((event, emit) => _fieldsEntered(event, emit));
    on<LoginBtnPressedEvent>(
        (event, emit) => _loginBtnPressedEntered(event, emit));
    on<LoginErrorEvent>((event, emit) => _loginErrorEntered(event, emit));
  }

  _fieldsEntered(LoginFieldsEnteredEvent event, Emitter<LoginState> emit) {
    if (event.email.trim().isNotEmpty && event.password.trim().isNotEmpty) {
      emit(LoginValidState());
    } else {
      emit(LoginInitialState());
    }
  }

  _loginBtnPressedEntered(
      LoginBtnPressedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      DocumentSnapshot docSnap = await _fireStore
          .collection(AppStr.collectionUsers)
          .doc(user.user!.uid)
          .get();
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
      var hive = HiveClass().getBox(boxName: AppStr.userHiveBox);
      hive.add(UserModel.fromJSON(data));
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      add(LoginErrorEvent(error: e.message.toString()));
    } catch (e) {
      add(LoginErrorEvent(error: e.toString()));
    }
  }

  _loginErrorEntered(LoginErrorEvent event, Emitter<LoginState> emit) {
    emit(LoginErrorState(error: event.error));
  }
}
