import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/model/movie_item_ui_model.dart';
import 'package:movies_app/model/my_user.dart';

class FirebaseUtils {
  static const String watchlistCollectionName = 'Watchlist';
  static const String historyCollectionName = 'History';

  static CollectionReference<MovieItemUiModel> getHistoryCollection(
      String userId,) {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(userId)
        .collection(historyCollectionName)
        .withConverter<MovieItemUiModel>(
      fromFirestore: (snapshot, options) =>
          MovieItemUiModel.fromJson(snapshot.data()!),
      toFirestore: (movie, options) => movie.toJson(),
    );
  }
  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromJson(snapshot.data()!),
          toFirestore: (user, options) => user.toJson(),
        );
  }
  static CollectionReference<MovieItemUiModel> getWatchlistCollection(
      String userId,) {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(userId)
        .collection(watchlistCollectionName)
        .withConverter<MovieItemUiModel>(
      fromFirestore: (snapshot, options) =>
          MovieItemUiModel.fromJson(snapshot.data()!),
      toFirestore: (movie, options) => movie.toJson(),
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

  static Future<void> addToWatchlist(String userId, MovieItemUiModel  movie) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Watchlist')
        .doc(movie.id)
        .set(movie.toJson());
  }

  static Future<void> removeFromWatchlist(String userId, String movieId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Watchlist')
        .doc(movieId)
        .delete();
  }
  static Stream<List<MovieItemUiModel>> getWatchlistStream(String userId) {
    return getWatchlistCollection(userId).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }
  static Stream<List<MovieItemUiModel>> getHistoryStream(String userId) {
    return getHistoryCollection(userId).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }
  static Future<void> addToHistory(String userId, MovieItemUiModel movie) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('History')
        .doc(movie.id)
        .set(movie.toJson());
  }
}

