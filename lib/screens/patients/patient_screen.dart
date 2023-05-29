import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medi_care/models/patient.dart';

import '../../services/save_patient_service.dart';
import '../../services/update_patient_service.dart';
import '../../shared/background_wave_container.dart';
import '../../shared/input_field.dart';

class PatientScreen extends StatefulWidget {
  PatientScreen({this.existingPatient, Key? key}) : super(key: key);

  Patient? existingPatient;
  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  String name = "";
  String address = "";
  int age = 20;
  int? fbs;
  int? bpressure;
  String? allergics;
  String? other;
  List<MediRecord>? mediRecords = [];

  List<TextEditingController> dateControllers = [
    TextEditingController(text: DateTime.now().toString())
  ];
  final ScrollController _scrollController = ScrollController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool editMode = true;

  @override
  void initState() {
    super.initState();
    if (widget.existingPatient != null) {
      editMode = false;
      name = widget.existingPatient!.name;
      address = widget.existingPatient!.address;
      age = widget.existingPatient!.age;
      fbs = widget.existingPatient!.fbs;
      bpressure = widget.existingPatient!.bpressure;
      allergics = widget.existingPatient!.allergics;
      other = widget.existingPatient!.other;
      mediRecords = widget.existingPatient!.mediRecords;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        BackgroundWaveContainer(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back)),
              Text(
                  widget.existingPatient == null
                      ? 'Add New Patient'
                      : "View Patient",
                  style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "Signika")),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.existingPatient != null
                  ? "ID: ${widget.existingPatient!.id!}"
                  : ""),
              editMode
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(80, 20),
                        primary: Colors.teal,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                      ),
                      onPressed: () async {
                        //  if (name != "" || address != "") {
                        if (_formKey1.currentState != null &&
                            _formKey1.currentState!.validate()) {
                          var result;
                          Patient patient = Patient(
                              name: name,
                              address: address,
                              age: age,
                              fbs: fbs,
                              bpressure: bpressure,
                              allergics: allergics,
                              other: other,
                              mediRecords: mediRecords);
                          if (widget.existingPatient != null) {
                            result = await updatePatient(
                                patient, widget.existingPatient!.id);
                          } else {
                            result = await savePatient(patient);
                          }
                          print(result);
                          if (result == true) {
                            Get.snackbar(
                              "Staus",
                              "Patient saved successfully",
                              backgroundColor: Colors.teal,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            if (widget.existingPatient != null) {
                              setState(() {
                                editMode = false;
                              });
                            }
                          } else {
                            Get.snackbar(
                              "Staus",
                              "Error in saving patient",
                              backgroundColor: Colors.teal,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        } else {
                          Get.snackbar(
                            "Staus",
                            "Error in saving patient, Please fill the form correctly",
                            backgroundColor: Colors.teal,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.save,
                            size: 20,
                          ),
                          const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          editMode = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.edit),
                          const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(80, 20),
                        // primary: Colors.teal,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        DefaultTabController(
            length: 2, // Length of tabs.
            initialIndex: 0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TabBar(
                    labelColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    indicatorColor: Colors.deepPurple,
                    tabs: [
                      Tab(text: 'About Patient'),
                      Tab(text: 'Medical Records'),
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      height: 550, // Height of TabBarView.
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.7))),
                      child: TabBarView(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey1,
                            child: SizedBox(
                              height: 380,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    InputField(
                                      label: 'Name',
                                      initialValue: name,
                                      onValidateCallback: onValidateField,
                                      readOnly: !editMode,
                                      onChangeCallback: (val) {
                                        setState(() {
                                          name = val;
                                        });
                                      },
                                    ),
                                    InputField(
                                      label: 'Address',
                                      initialValue: address,
                                      onValidateCallback: onValidateField,
                                      readOnly: !editMode,
                                      onChangeCallback: (val) {
                                        setState(() {
                                          address = val;
                                        });
                                      },
                                    ),
                                    InputField(
                                      label: 'Age',
                                      initialValue: age.toString(),
                                      onValidateCallback: onValidateField,
                                      readOnly: !editMode,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChangeCallback: (val) {
                                        setState(() {
                                          age = int.parse(val);
                                        });
                                      },
                                    ),
                                    InputField(
                                      label: 'FBS Level',
                                      initialValue:
                                          fbs == null ? "" : fbs.toString(),
                                      onValidateCallback: onValidateField,
                                      readOnly: !editMode,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChangeCallback: (val) {
                                        setState(() {
                                          fbs = int.parse(val);
                                        });
                                      },
                                    ),
                                    InputField(
                                      label: 'Blood Pressure',
                                      initialValue: bpressure == null
                                          ? ""
                                          : bpressure.toString(),
                                      onValidateCallback: onValidateField,
                                      readOnly: !editMode,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChangeCallback: (val) {
                                        setState(() {
                                          bpressure = int.parse(val);
                                        });
                                      },
                                    ),
                                    InputField(
                                      label: 'Allergics',
                                      initialValue: allergics == null
                                          ? ""
                                          : allergics.toString(),
                                      onValidateCallback: onValidateField,
                                      readOnly: !editMode,
                                      onChangeCallback: (val) {
                                        setState(() {
                                          allergics = val;
                                        });
                                      },
                                    ),
                                    InputField(
                                      label: 'Other Notes',
                                      initialValue:
                                          other == null ? "" : other.toString(),
                                      onValidateCallback: onValidateField,
                                      readOnly: !editMode,
                                      maxLines: 2,
                                      onChangeCallback: (val) {
                                        setState(() {
                                          other = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: editMode
                                          ? () {
                                              setState(() {
                                                mediRecords!.add(MediRecord(
                                                    DateTime.now(), "", ""));
                                                dateControllers.add(
                                                    TextEditingController(
                                                        text: DateTime.now()
                                                            .toString()));
                                              });
                                              scrollDown();
                                            }
                                          : null,
                                      icon: Icon(Icons.add_circle)),
                                ],
                              ),
                              SizedBox(
                                height: 450,
                                child: Form(
                                  key: _formKey2,
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.zero,
                                      itemCount: mediRecords!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20)),
                                            color: Color.fromARGB(
                                                255, 233, 239, 237),
                                          ),
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text("Record ${index + 1}"),
                                                  IconButton(
                                                      onPressed: editMode
                                                          ? () {
                                                              setState(() {
                                                                mediRecords!
                                                                    .removeAt(
                                                                        index);
                                                                dateControllers
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                            }
                                                          : null,
                                                      icon: Icon(Icons.delete)),
                                                ],
                                              ),
                                              TextFormField(
                                                  controller: dateControllers[
                                                      index], //editing controller of this TextField
                                                  validator: (value) {
                                                    return onValidateField(
                                                        value);
                                                  },
                                                  readOnly: !editMode,
                                                  decoration:
                                                      const InputDecoration(
                                                          icon: Icon(Icons
                                                              .calendar_today), //icon of text field
                                                          labelText:
                                                              "Enter Date" //label text of field
                                                          ),
                                                  onTap: editMode
                                                      ? () async {
                                                          //when click we have to show the datepicker

                                                          DateTime? pickedDate =
                                                              await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                          2000),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2101));
                                                          setState(() {
                                                            mediRecords![index]
                                                                    .date =
                                                                pickedDate!;
                                                            dateControllers[
                                                                        index]
                                                                    .text =
                                                                pickedDate
                                                                    .toString();
                                                          });
                                                        }
                                                      : null),
                                              InputField(
                                                label: "Disease",
                                                initialValue:
                                                    mediRecords![index].disease,
                                                onValidateCallback:
                                                    onValidateField,
                                                readOnly: !editMode,
                                                maxLines: 1,
                                                onChangeCallback: (val) {
                                                  setState(() {
                                                    mediRecords![index]
                                                        .disease = val;
                                                  });
                                                },
                                              ),
                                              InputField(
                                                label: "Treatment",
                                                initialValue:
                                                    mediRecords![index]
                                                        .treatment,
                                                onValidateCallback:
                                                    onValidateField,
                                                readOnly: !editMode,
                                                maxLines: 1,
                                                onChangeCallback: (val) {
                                                  setState(() {
                                                    mediRecords![index]
                                                        .treatment = val;
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]))
                ])),
      ]),
    );
  }

  String? onValidateField(val) {
    if (val == null || val.isEmpty || val == "") {
      return "This field can't be empty";
    }
    return null;
  }

  // onChangeHouseNumber(val) {
  //   // if (isSubmitted) {
  //   //   _formKey.currentState!.validate();
  //   // }
  //   setState(() {
  //     // houseNumber = val;
  //   });
  // }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}
