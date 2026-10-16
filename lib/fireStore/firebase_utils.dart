import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/my_user.dart';

class FirebaseUtils {
  // CollectionReference مع Converter للتحويل التلقائي من وإلى MyUser
  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromJson(snapshot.data()!),
          toFirestore: (user, options) => user.toJson(),
        );
  }

  // 1. إضافة مستخدم جديد في Firestore
  static Future<void> addUserToFireStore(MyUser user) {
    return getUserCollection().doc(user.id).set(user);
  }

  // 2. جلب بيانات مستخدم بواسطة الـ ID
  static Future<MyUser?> getUser(String userId) async {
    var docSnapshot = await getUserCollection().doc(userId).get();
    return docSnapshot.data();
  }

  // 3. تحديث بيانات المستخدم (الاسم، الهاتف، الأفاتار)
  static Future<void> updateUser(MyUser user) {
    return getUserCollection().doc(user.id).update(user.toJson());
  }

  // 4. حذف بيانات المستخدم من Firestore
  static Future<void> deleteUser(String userId) {
    return getUserCollection().doc(userId).delete();
  }
}
