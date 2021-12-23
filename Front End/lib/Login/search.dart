import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class searchPatients extends StatefulWidget {
  final hospital_id;
  searchPatients({this.hospital_id});
  @override
  _searchPatientsState createState() => _searchPatientsState();
}

class _searchPatientsState extends State<searchPatients> {
  @override
      void initState() {
        super.initState();
        getDriversList().then((results) {
          setState(() {
            querySnapshot = results.docs[0].data();
            user=querySnapshot;
          });
        });
      }
  late QuerySnapshot querySnapshot;
  late var user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showDrivers(),
    );
  }
Widget _showDrivers() {
        //check if querysnapshot is null
        if (querySnapshot != null) {
          return ListView.builder(
            primary: false,
            itemCount: user["Patients"].length,
            padding: EdgeInsets.only(top: 400),
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
//load data into widgets
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("${user["Patients"][i].toString().split("_")[0]} ${user["Patients"][i].toString().split("_")[1]}"),
                  )
                ],
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }

      //get firestore instance
      getDriversList() async {
        return await FirebaseFirestore.instance.collection(widget.hospital_id).get();
      }
    }