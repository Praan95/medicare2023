import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/patient.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('users');

Future<bool> updatePatient(Patient patient, String? documentId) async {
  bool result = false;
  var email = FirebaseAuth.instance.currentUser!.email;
  List mediRecords = [];

  for (var element in patient.mediRecords!) {
    mediRecords.add({
      "date": element.date,
      "disease": element.disease,
      "treatment": element.treatment,
    });
  }
  await _mainCollection.doc(email).collection("patients").doc(documentId).set({
    "name": patient.name,
    "address": patient.address,
    "age": patient.age,
    "fbs": patient.fbs,
    "bpressure": patient.bpressure,
    "allergics": patient.allergics,
    "other": patient.other,
    "mediRecords": mediRecords,
  }, SetOptions(merge: true)).then((value) {
    print("Patient saved successfully");
    result = true;
  }).catchError((error) {
    print("Failed to save patient: $error");
    result = false;
  });
  return result;
}
