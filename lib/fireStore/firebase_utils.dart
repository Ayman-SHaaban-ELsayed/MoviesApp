import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/model/my_user.dart';

class FirebaseUtils {
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
}
