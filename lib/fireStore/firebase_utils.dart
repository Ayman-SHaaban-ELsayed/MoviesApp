import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/model/my_user.dart';
import 'package:movies_app/model/movie_item_ui_model.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/cubit/profile_states.dart';

class FirebaseUtils {
  static const String watchlistCollectionName = 'watchlist';
  static const String historyCollectionName = 'history';

  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromJson(snapshot.data()!),
          toFirestore: (user, options) => user.toJson(),
        );
  }

  static Future<void> addUserToFireStore(MyUser user) {
    return getUserCollection().doc(user.id).set(user);
  }

  static Future<MyUser?> getUser(String userId) async {
    var docSnapshot = await getUserCollection().doc(userId).get();
    return docSnapshot.data();
  }

  static Future<void> updateUser(MyUser user) {
    return getUserCollection().doc(user.id).update(user.toJson());
  }

  static Future<void> deleteUser(String userId) {
    return getUserCollection().doc(userId).delete();
  }
  static Future<bool> isMovieInWatchlist(String userId, String movieId) async {
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Watchlist')
        .doc(movieId)
        .get();
    return doc.exists;
  }

  // 2. إضافة فيلم للـ Watchlist
  static Future<void> addToWatchlist(String userId, MovieItemUiModel movie) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Watchlist')
        .doc(movie.id)
        .set(movie.toJson());
  }

  // 3. مسح فيلم من الـ Watchlist
  static Future<void> removeFromWatchlist(String userId, String movieId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Watchlist')
        .doc(movieId)
        .delete();
  }

  // 4. إضافة فيلم للـ History
  static Future<void> addToHistory(String userId, MovieItemUiModel movie) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('History')
        .doc(movie.id)
        .set(movie.toJson());
  }
}

