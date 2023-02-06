import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;

  DataBaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

//updating the userdata
  Future updateUserData(
      {required String fullName, required String email}) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profilePic': '',
      'uid': uid
    });
  }

//getting User data

  Future gettingUserData(String email) async =>
      await userCollection.where('email', isEqualTo: email).get();
}
