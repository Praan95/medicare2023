import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_care/models/patient.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('users');

Future fetchDashbdData() async {
  late QuerySnapshot querySnapshot;
  var email = FirebaseAuth.instance.currentUser!.email;
  var temp = [];
  int totalPatients = 0;
  int todayPatients = 0;

  try {
    querySnapshot =
        await _mainCollection.doc(email).collection('patients').get();
    totalPatients = querySnapshot.docs.length;
    for (var result in querySnapshot.docs) {
      temp.add(result.data());
    }
    for (var item in temp) {
      if (item['added_date'] == DateTime.now()) {
        todayPatients++;
      }
    }
  } catch (e) {
    print("Error");
    print(e);
  } finally {
    print(todayPatients);
    return {"todayPatients": todayPatients, "totalPatients": totalPatients};
  }
}
