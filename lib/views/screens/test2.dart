import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  Test({super.key});

  final String title = "test";

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var carMake, carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('carMake: $carMake');
    debugPrint('carMakeModel: $carMakeModel');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('carMake')
                    .orderBy('name')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Safety check to ensure that snapshot contains data
                  // without this safety check, StreamBuilder dirty state warnings will be thrown
                  if (!snapshot.hasData) return Container();
                  // Set this value for default,
                  // setDefault will change if an item was selected
                  // First item from the List will be displayed
                  if (setDefaultMake) {
                    carMake = snapshot.data!.docs[0].get('name');
                    debugPrint('setDefault make: $carMake');
                  }
                  return DropdownButton(
                    isExpanded: false,
                    value: carMake,
                    items: snapshot.data!.docs.map((value) {
                      return DropdownMenuItem(
                        value: value.get('name'),
                        child: Text('${value.get('name')}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      debugPrint('selected onchange: $value');
                      setState(
                        () {
                          debugPrint('make selected: $value');
                          // Selected value will be stored
                          carMake = value;
                          // Default dropdown value won't be displayed anymore
                          setDefaultMake = false;
                          // Set makeModel to true to display first car from list
                          setDefaultMakeModel = true;
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: carMake != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cars')
                          .where('make', isEqualTo: carMake)
                          .orderBy("makeModel").snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          debugPrint('snapshot status: ${snapshot.error}');
                          return Container(
                            child:
                            Text(
                                'snapshot empty carMake: $carMake makeModel: $carMakeModel'),
                          );
                        }
                        if (setDefaultMakeModel) {
                          carMakeModel = snapshot.data!.docs[0].get('makeModel');
                          debugPrint('setDefault makeModel: $carMakeModel');
                        }
                        return DropdownButton(
                          isExpanded: false,
                          value: carMakeModel,
                          items: snapshot.data!.docs.map((value) {
                            debugPrint('makeModel: ${value.get('makeModel')}');
                            return DropdownMenuItem(
                              value: value.get('makeModel'),
                              child: Text(
                                '${value.get('makeModel')}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            debugPrint('makeModel selected: $value');
                            setState(
                              () {
                                // Selected value will be stored
                                carMakeModel = value;
                                // Default dropdown value won't be displayed anymore
                                setDefaultMakeModel = false;
                              },
                            );
                          },
                        );
                      },
                    )
                  : Container(
                      child: Text('carMake null carMake: $carMake makeModel: $carMakeModel'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

