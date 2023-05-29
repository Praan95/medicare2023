import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_care/models/patient.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('users');

Future<List<Patient>> fetchPatients() async {
  List<Patient> allPatients = [];
  late QuerySnapshot querySnapshot;
  var email = FirebaseAuth.instance.currentUser!.email;
  var temp = [];
  var ids = [];

  try {
    querySnapshot =
        await _mainCollection.doc(email).collection('patients').get();
    for (var result in querySnapshot.docs) {
      ids.add(result.id);
      temp.add(result.data());
    }

    for (int i = 0; i < temp.length; i++) {
      var item = temp[i];
      List<MediRecord> mediRecords = [];
      for (var rec in item['mediRecords']) {
        mediRecords.add(
            MediRecord(rec['date'].toDate(), rec['disease'], rec['treatment']));
      }
      allPatients.add(Patient(
          id: ids[i],
          name: item['name'],
          address: item["address"],
          age: item['age'],
          fbs: item['fbs'],
          bpressure: item['bpressure'],
          allergics: item['allergics'],
          other: item['other'],
          mediRecords: mediRecords));
    }
    print(allPatients);
  } catch (e) {
    print("Error");
    print(e);
  } finally {
    return allPatients;
  }
}
