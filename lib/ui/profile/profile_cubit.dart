import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../fireStore/firebase_utils.dart';
import '../../model/my_user.dart';
import '../../utils/shared_pref_utils.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  MyUser? currentUser;
  int watchListCount = 12;
  int historyCount = 10;
  List<MovieItemUiModel> watchListMovies = [];
  List<MovieItemUiModel> historyMovies = [];

  Future<void> loadUser([MyUser? initialUser]) async {
    emit(ProfileLoadingState());

    if (initialUser != null) {
      currentUser = initialUser;
      _emitLoaded();
      return;
    }

    final userId = SharedPrefUtils.userId;
    if (userId != null && userId.isNotEmpty) {
      try {
        final fetchedUser = await FirebaseUtils.getUser(userId);
        if (fetchedUser != null) {
          currentUser = fetchedUser;
          _emitLoaded();
          return;
        }
      } catch (_) {
        // Fallback to default user if network or Firestore fails
      }
    }

    // Default mock user for standalone UI preview
    currentUser = MyUser(
      id: userId ?? 'preview_user',
      name: 'John Doe',
      email: 'johndoe@example.com',
      phone: '+20 123 456 7890',
      avatarId: 1,
    );

    _emitLoaded();
  }

  void _emitLoaded() {
    emit(
      ProfileLoadedState(
        user: currentUser!,
        watchListCount: watchListCount,
        historyCount: historyCount,
        watchListMovies: watchListMovies,
        historyMovies: historyMovies,
      ),
    );
  }

  void selectAvatar(int avatarId) {
    if (currentUser == null) return;
    currentUser = MyUser(
      id: currentUser!.id,
      name: currentUser!.name,
      email: currentUser!.email,
      phone: currentUser!.phone,
      avatarId: avatarId,
    );
    _emitLoaded();
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarId,
  }) async {
    if (currentUser == null) return;
    emit(ProfileUpdatingState());
    try {
      final updatedUser = MyUser(
        id: currentUser!.id,
        name: name,
        email: currentUser!.email,
        phone: phone,
        avatarId: avatarId,
      );

      // Attempt Firestore update if user has a valid cloud ID
      if (updatedUser.id.isNotEmpty && updatedUser.id != 'preview_user') {
        await FirebaseUtils.updateUser(updatedUser);
      }

      currentUser = updatedUser;
      emit(ProfileUpdatedSuccessState(user: updatedUser));
      _emitLoaded();
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
      _emitLoaded();
    }
  }

  Future<void> resetPassword() async {
    if (currentUser == null || currentUser!.email.isEmpty) return;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: currentUser!.email,
      );
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
      _emitLoaded();
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await SharedPrefUtils.saveUserId('');
      emit(ProfileLogoutSuccessState());
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
      _emitLoaded();
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseUtils.deleteUser(user.uid);
        await user.delete();
      }
      await SharedPrefUtils.saveUserId('');
      emit(ProfileDeleteSuccessState());
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
      _emitLoaded();
    }
  }
}
