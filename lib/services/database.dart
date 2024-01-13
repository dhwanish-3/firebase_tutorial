import 'package:firebase_tutorial/constants/imports.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ''});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('PatientUsers');

  Future<void> updateUserData(
      String uid,
      String name,
      String nickName,
      String imageUrl,
      String dob,
      int height,
      int weight,
      bool smoker,
      bool alcoholic,
      bool physicallyActive,
      bool pwd,
      int percentageDisability) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'nickName': nickName,
      'imageUrl': imageUrl,
      'dob': dob,
      'height': height,
      'weight': weight,
      'isSmoker': smoker,
      'isAlcoholic': alcoholic,
      'isPhysicallyActive': physicallyActive,
      'isPhysicallyChallenged': pwd,
      'percentageofDisability': percentageDisability
    });
  }

  // brew list from snapshot
  // List<PatientUser> brewListFromSnapshot(QuerySnapshot snapshot) {
  // return snapshot.docs.map((doc) {
  //   return Brew(
  //       name: doc.get('name'),
  //       strength: doc.get('strength'),
  //       sugars: doc.get('sugars'));
  // }).toList();
  // }

  // user data from snapshots
  PatientUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return PatientUser(
      uid: uid,
      birthDate: snapshot.get('birthDate'),
      imageUrl: snapshot.get('ImageUrl'),
      emailid: snapshot.get('emailid'),
      name: snapshot.get('name'),
      nickName: snapshot.get('nickName'),
      age: snapshot.get('age'),
      gender: snapshot.get('gender'),
      height: snapshot.get('height'),
      isAlcoholic: snapshot.get('isAlcoholic'),
      isPhysicalActive: snapshot.get('isPhysicallyActive'),
      isPhysicallyChallenged: snapshot.get('isPhysicallyChallenged'),
      isSmoker: snapshot.get('isSmoker'),
      weight: snapshot.get('weight'),
    );
  }

  // get brews stream
  // Stream<List<PatientUser>> get brews {
  //   return userCollection.snapshots().map(brewListFromSnapshot);
  // }

  // get user doc stream
  Stream<PatientUser> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
