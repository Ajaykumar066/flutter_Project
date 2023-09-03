import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_gdsc/button.dart';
import 'package:for_gdsc/helper.dart';
import 'package:for_gdsc/text_file.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final nameController = TextEditingController();
  final sidController = TextEditingController();
  final spController = TextEditingController();
  final cgpaController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var sname, sid, sprogram, scgpa;

  @override
  void dispose() {
    // TODO : implement dispose
    super.dispose();
    nameController.dispose();
    sidController.dispose();
    spController.dispose();
    cgpaController.dispose();
  }

  getName(name) {
    sname = name;
  }

  getID(ID) {
    sid = ID;
  }

  getProgram(studentProgram) {
    sprogram = studentProgram;
  }

  getCGPA(CGPA) {
    scgpa = CGPA;
  }

  createData() async {
    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("student").doc(sname);

    Map<String, dynamic> sdata = {
      "Name": sname,
      "Student ID": sid,
      "Student Program": sprogram,
      "CGPA": scgpa,
    };
    documentReference
        .set(sdata)
        .whenComplete(() => print("Create Sucessfully"));
  }

  readData() async {
    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("Student").doc(sname);
    documentReference.get().whenComplete(() => print("Readed Sucessfully"));
  }

  updateData() async {
    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("Student").doc(sname);

    Map<String, dynamic> sdata = {
      "Name": sname,
      "Student ID": sid,
      "Student Program": sprogram,
      "CGPA": scgpa,
    };
    documentReference
        .update(sdata)
        .whenComplete(() => print("Update Sucessfully"));
  }

  deleteData() async {
    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("Student").doc(sname);

    documentReference.delete().whenComplete(() => print("Deleted Sucessfully"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          backgroundColor: Colors.yellow,
          title: Text(
            "Student App",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ), //AppBar
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 80,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextBox(
                  filedType: "Name",
                  controller: nameController,
                  change: (name) {
                    getName(name);
                  },
                ),
                TextBox(
                  filedType: "Student ID",
                  controller: sidController,
                  change: (id) {
                    getID(id);
                  },
                ),
                TextBox(
                  filedType: "Student Program",
                  controller: spController,
                  change: (program) {
                    getProgram(program);
                  },
                ),
                TextBox(
                  filedType: "CGPA",
                  controller: cgpaController,
                  change: (cgpa) {
                    getCGPA(cgpa);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Buttons(
                      Btntext: "Create",
                      color: Colors.purple,
                      onclick: () {
                        createData();
                      },
                    ), // Buttons
                    Buttons(
                      Btntext: "Read",
                      color: Colors.green,
                      onclick: () {
                        setState(() {});
                      },
                    ), // Buttons
                    Buttons(
                      Btntext: "update",
                      color: Colors.blue,
                      onclick: () {
                        updateData();
                      },
                    ),
                    Buttons(
                      Btntext: "delete",
                      color: Colors.red,
                      onclick: () {
                        deleteData();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    ShowData(
                      type: "Name",
                      isHeading: true,
                    ),
                    ShowData(
                      type: "Student ID",
                      isHeading: true,
                    ),
                    ShowData(
                      type: "Student Program",
                      isHeading: true,
                    ),
                    ShowData(
                      type: "CGPA",
                      isHeading: true,
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('student')
                        .snapshots(),
                    builder: (context, snapshot) => Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> mp =
                                  snapshot.data!.docs[index].data();
                              return Row(
                                children: [
                                  ShowData(type: mp['Name']),
                                  ShowData(type: mp['Student ID']),
                                  ShowData(type: mp['Student Program']),
                                  ShowData(type: mp['CGPA']),
                                ],
                              );
                            },
                          ),
                        ))
              ])),
        ),
      ),
    );
  }
}
