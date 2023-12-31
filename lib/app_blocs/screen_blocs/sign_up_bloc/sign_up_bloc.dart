import 'package:bloc/bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/sign_up_bloc/sign_up_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/sign_up_bloc/sign_up_states.dart';
import 'package:bloc_test/local_storage/hive/hive_class.dart';
import 'package:bloc_test/models/user_model/user_model.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpFieldsEnteredEvent>((event, emit) => _fieldsEntered(event, emit));
    on<SignUpBtnPressedEvent>((event, emit) => _signUpBtnPressed(event, emit));
    on<SignUpErrorEvent>((event, emit) => _signUpError(event, emit));
  }

  _fieldsEntered(SignUpFieldsEnteredEvent event, Emitter<SignUpState> emit) {
    if (event.name.trim().isNotEmpty &&
        event.email.trim().isNotEmpty &&
        event.phoneNumber.trim().isNotEmpty &&
        event.password.trim().isNotEmpty &&
        event.confirmPassword.trim().isNotEmpty) {
      emit(SignUpValidState());
    } else {
      emit(SignUpInitialState());
    }
  }

  _signUpBtnPressed(
      SignUpBtnPressedEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);

      Map<String, dynamic> map = {
        "id": credential.user!.uid,
        "name": event.name,
        "email": event.email,
        "phoneNumber": event.phoneNumber,
        "password": event.password,
      };
      await _fireStore
          .collection(AppStr.collectionUsers)
          .doc(credential.user!.uid)
          .set(map);
      var hive = HiveClass().getBox(boxName: AppStr.userHiveBox);
      hive.add(UserModel(
        id: credential.user!.uid,
        name: event.name,
        email: event.email,
        phoneNumber: event.phoneNumber,
      ));
      emit(SignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      add(SignUpErrorEvent(error: e.message.toString()));
    } catch (e) {
      add(SignUpErrorEvent(error: e.toString()));
    }
  }

  _signUpError(SignUpErrorEvent event, Emitter<SignUpState> emit) {
    emit(SignUpErrorState(error: event.error));
  }
}
