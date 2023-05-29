import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/fetch_patients_service.dart';
import '../../shared/background_wave_container.dart';
import 'patient_screen.dart';

class ViewPatientsListScreen extends StatefulWidget {
  const ViewPatientsListScreen({Key? key}) : super(key: key);

  @override
  State<ViewPatientsListScreen> createState() =>
      _ViewPatientsListScreenScreenState();
}

class _ViewPatientsListScreenScreenState extends State<ViewPatientsListScreen> {
  List allPatients = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPatientsList();
  }

  loadPatientsList() async {
    isLoading = true;
    allPatients = await fetchPatients();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: SliverSearchAppBar(),
                    // Set this param so that it won't go off the screen when scrolling
                    pinned: true,
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    var patient = allPatients[index];
                    return ListTile(
                      shape: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0),
                      ),
                      title: Text(
                        patient.name,
                        style: TextStyle(fontSize: 20),
                      ),
                      leading: Text(patient.age.toString()),
                      subtitle: Text(patient.address),
                      trailing: IconButton(
                          icon: Icon(Icons.arrow_circle_right_outlined),
                          onPressed: () {
                            Get.to(PatientScreen(
                              existingPatient: patient,
                            ));
                          }),
                    );
                  }, childCount: allPatients.length))
                ],
              ));
  }
}

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var adjustedShrinkOffset =
        shrinkOffset > minExtent ? minExtent : shrinkOffset;
    double offset = (minExtent - adjustedShrinkOffset) * 0.1;
    double topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        SizedBox(
          height: 280,
          child: ClipPath(
              clipper: BackgroundWaveClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 280,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.teal, Color.fromARGB(255, 91, 224, 193)],
                )),
              )),
        ),
        Positioned(
          top: topPadding + offset,
          left: 16,
          right: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const Text('My Patients',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "Signika")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimSearchBar(
                    helpText: 'Search by name',
                    onSubmitted: (String) {},
                    textController: TextEditingController(),
                    onSuffixTap: null,
                    width: MediaQuery.of(context).size.width - 32,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => 190;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}
