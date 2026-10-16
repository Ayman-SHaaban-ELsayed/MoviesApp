import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../fireStore/firebase_utils.dart';
import '../../model/my_user.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginInitialState());
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = await FirebaseUtils.getUser(credential.user?.uid ?? '');
      if (user == null) {
        emit(LoginErrorState(errorMessage: 'User data not found'));
        return;
      }

      emit(LoginSuccessState(user: user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        emit(LoginErrorState(errorMessage: 'Incorrect email or password'));
      } else if (e.code == 'network-request-failed') {
        emit(LoginErrorState(errorMessage: 'No internet connection'));
      } else if (e.code == 'too-many-requests') {
        emit(LoginErrorState(errorMessage: 'Too many attempts. Please try again later'));
      } else {
        emit(LoginErrorState(errorMessage: e.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(LoginErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(GoogleLoginLoadingState());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(LoginInitialState());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final uid = userCredential.user?.uid ?? '';
      MyUser? user = await FirebaseUtils.getUser(uid);

      if (user == null) {
        user = MyUser(
          id: uid,
          name: userCredential.user?.displayName ?? 'User',
          email: userCredential.user?.email ?? '',
          phone: userCredential.user?.phoneNumber ?? '',
          avatarId: 1,
        );
        await FirebaseUtils.addUserToFireStore(user);
      }

      emit(LoginSuccessState(user: user));
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(errorMessage: e.message ?? 'Google sign in failed'));
    } catch (e) {
      emit(LoginErrorState(errorMessage: e.toString()));
    }
  }
}
