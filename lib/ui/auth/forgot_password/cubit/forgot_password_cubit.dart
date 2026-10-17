import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password_states.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  Future<void> sendResetLink({required String email}) async {
    emit(ForgotPasswordLoadingState());
    try {
      final trimmedEmail = email.trim();

      // 1. التحقق هل الإيميل مسجل مسبقاً في الـ Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: trimmedEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // لو الداتا خالية، معناه إن الإيميل مش مسجل
        emit(ForgotPasswordErrorState(
            errorMessage: 'No account found with this email'));
        return;
      }

      // 2. لو الإيميل موجود، يتم إرسال رابط إعادة التعيين
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: trimmedEmail,
      );

      emit(ForgotPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
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