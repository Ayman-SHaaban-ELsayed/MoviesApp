import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../fireStore/firebase_utils.dart';
import '../../../../model/my_user.dart';

import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  int selectedAvatarId = 1;

  void changeAvatar(int newAvatarId) {
    selectedAvatarId = newAvatarId;
    emit(RegisterInitialState());
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      MyUser user = MyUser(
        id: credential.user?.uid ?? '',
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        avatarId: selectedAvatarId,
      );

      await FirebaseUtils.addUserToFireStore(user);

      emit(RegisterSuccessState(user: user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterErrorState(errorMessage: 'The password provided is too weak'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterErrorState(errorMessage: 'An account already exists for that email'));
      } else if (e.code == 'invalid-email') {
        emit(RegisterErrorState(errorMessage: 'The email address is not valid'));
      } else {
        emit(RegisterErrorState(errorMessage: e.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(RegisterErrorState(errorMessage: e.toString()));
    }
  }
}
