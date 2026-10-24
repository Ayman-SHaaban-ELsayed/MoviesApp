import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/fireStore/firebase_utils.dart';
import 'package:movies_app/model/movie_item_ui_model.dart';
import 'package:movies_app/model/my_user.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/cubit/profile_states.dart';
import 'package:movies_app/utils/shared_pref_utils.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  MyUser? currentUser;
  int watchListCount = 0;
  int historyCount = 0;
  List<MovieItemUiModel> watchListMovies = [];
  List<MovieItemUiModel> historyMovies = [];

  StreamSubscription<List<MovieItemUiModel>>? _watchListSubscription;
  StreamSubscription<List<MovieItemUiModel>>? _historySubscription;

  Future<void> loadUser([MyUser? initialUser]) async {
    emit(ProfileLoadingState());

    if (initialUser != null) {
      currentUser = initialUser;
      _subscribeToWatchlistAndHistory(currentUser!.id);
      _emitLoaded();
      return;
    }

    final userId =
        FirebaseAuth.instance.currentUser?.uid ?? SharedPrefUtils.userId;
    if (userId != null && userId.isNotEmpty) {
      try {
        final fetchedUser = await FirebaseUtils.getUser(userId);
        if (fetchedUser != null) {
          currentUser = fetchedUser;
          final firebaseUser = FirebaseAuth.instance.currentUser;
          final googleName = firebaseUser?.displayName?.trim();
          final isGoogleUser = firebaseUser?.providerData
              .any((p) => p.providerId == 'google.com') ??
              false;
          if (isGoogleUser &&
              googleName != null &&
              googleName.isNotEmpty &&
              currentUser!.name != googleName) {
            currentUser!.name = googleName;
            unawaited(FirebaseUtils.updateUser(currentUser!));
          }
          _subscribeToWatchlistAndHistory(currentUser!.id);
          _emitLoaded();
          return;
        }
      } catch (_) {}
    }

    currentUser = MyUser(
      id: userId ?? 'preview_user',
      name: 'John Doe',
      email: 'johndoe@example.com',
      phone: '+20 123 456 7890',
      avatarId: 1,
    );

    _subscribeToWatchlistAndHistory(currentUser!.id);
    _emitLoaded();
  }

  void _subscribeToWatchlistAndHistory(String userId) {
    _watchListSubscription?.cancel();
    _historySubscription?.cancel();

    if (userId.isEmpty || userId == 'preview_user') {
      watchListMovies = [];
      watchListCount = 0;
      historyMovies = [];
      historyCount = 0;
      return;
    }

    _watchListSubscription = FirebaseUtils.getWatchlistStream(userId).listen(
          (movies) {
        watchListMovies = movies;
        watchListCount = movies.length;
        if (currentUser != null) {
          _emitLoaded();
        }
      },
      onError: (_) {},
    );

    _historySubscription = FirebaseUtils.getHistoryStream(userId).listen(
          (movies) {
        historyMovies = movies;
        historyCount = movies.length;
        if (currentUser != null) {
          _emitLoaded();
        }
      },
      onError: (_) {},
    );
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

  @override
  Future<void> close() {
    _watchListSubscription?.cancel();
    _historySubscription?.cancel();
    return super.close();
  }
}
