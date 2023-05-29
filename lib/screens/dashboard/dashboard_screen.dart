import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/fetch_dashbd_service.dart';
import '../../shared/background_wave_container.dart';
import '../patients/view_patients_screen.dart';
import 'package:particles_flutter/particles_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var data = {};
  @override
  void initState() {
    super.initState();
    loadDashbdData();
  }

  loadDashbdData() async {
    data = await fetchDashbdData();
    setState(() {});
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Container(
      //   color: Colors.white,
      //   child: CircularParticle(
      //     height: MediaQuery.of(context).size.height,
      //     width: MediaQuery.of(context).size.width,
      //     isRandomColor: false,
      //     particleColor: Color.fromARGB(118, 128, 0, 0),
      //     numberOfParticles: 50,
      //     connectDots: true,
      //   ),
      // ),
      Column(
        children: [
          BackgroundWaveContainer(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    'Hello ${FirebaseAuth.instance.currentUser!.displayName != null ? FirebaseAuth.instance.currentUser!.displayName! : ''}',
                    style: const TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: "Signika")),
                IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    elevation: 5,
                    color: Color.fromARGB(255, 1, 1, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Today patients",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              data['todayPatients'].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50),
                            ),
                          ]),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    elevation: 5,
                    color: Color.fromARGB(255, 1, 1, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total patients",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              data['totalPatients'].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50),
                            ),
                          ]),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 50),
                          primary: Colors.deepPurple[600],
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                        ),
                        onPressed: () {
                          Get.to(ViewPatientsListScreen());
                        },
                        child: Text("View My Patients"))),
              ],
            ),
          )
        ],
      ),
    ]);
  }
}
