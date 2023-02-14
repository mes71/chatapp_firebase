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

  //get user groups

  Future getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //create groups

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupReference = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': "",
      'admin': "${id}_$userName",
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupReference.update({
      'members': FieldValue.arrayUnion(['${uid}_$userName']),
      'groupId': groupReference.id
    });

    DocumentReference userReference = userCollection.doc(uid);
    return await userReference.update({
      'groups': FieldValue.arrayUnion(['${groupReference.id}_$groupName'])
    });
  }
}
