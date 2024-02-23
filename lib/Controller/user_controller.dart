import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtouch_machine_test/Model/user_model.dart';

class UserController {
  Future<void> createUser({required UserModel userModel}) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference categories = FirebaseFirestore.instance.collection(
        'users',
      );

      DocumentReference docRef = categories.doc();

      // set uid as document Id
      userModel.uid = docRef.id;

      Map<String, dynamic> user = userModel.toJson();

      await docRef.set(user);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> updateUser({required UserModel userModel}) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference categories = FirebaseFirestore.instance.collection(
        'users',
      );

      DocumentReference docRef = categories.doc(userModel.uid);

      Map<String, dynamic> user = userModel.toJson();

      await docRef.update(user);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> deleteUser({required UserModel userModel}) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference categories = FirebaseFirestore.instance.collection(
        'users',
      );

      DocumentReference docRef = categories.doc(userModel.uid);

      await docRef.delete();
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<bool> checkTitleAlreadyExists(String title) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final collection = firestore.collection('users');

      // get all documents from collection

      final querySnapshot = await collection.where('title', isEqualTo: title).get();
      
      // return bool value true is docs is not empty
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw (
        e.
        toString()
      );
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    // init firestore
    try {
      final firestore = FirebaseFirestore.instance;

      final collection = firestore.collection('users');

      // get all documents from collection

      final querySnapshot = await collection.get();

      final collectionList = querySnapshot.docs
          .map(
            (doc) => UserModel.fromJson(doc.data()),
          )
          .toList();

      return collectionList;
    } catch (e) {
      throw (e.toString());
    }
  }
}
