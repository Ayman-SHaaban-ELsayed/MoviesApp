import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password_states.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  Future<void> sendResetLink({required String email}) async {
    emit(ForgotPasswordLoadingState());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );
      emit(ForgotPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(ForgotPasswordErrorState(
            errorMessage: 'No account found with this email'));
      } else if (e.code == 'network-request-failed') {
        emit(ForgotPasswordErrorState(errorMessage: 'No internet connection'));
      } else if (e.code == 'too-many-requests') {
        emit(ForgotPasswordErrorState(
            errorMessage: 'Too many attempts. Please try again later'));
      } else {
        emit(ForgotPasswordErrorState(
            errorMessage: e.message ?? 'Something went wrong'));
      }
    } catch (e) {
      emit(ForgotPasswordErrorState(errorMessage: e.toString()));
    }
  }
}
