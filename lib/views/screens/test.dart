import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  Test({super.key});

  final String title = "test";

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var category, categoryModel;
  var setDefaultcategoryname = true, setDefaultsubcategory = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('category: $category');
    debugPrint('categoryModel: $categoryModel');
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
                    .collection('category')
                    .orderBy('id')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Safety check to ensure that snapshot contains data
                  // without this safety check, StreamBuilder dirty state warnings will be thrown
                  if (!snapshot.hasData) return Container();
                  // Set this value for default,
                  // setDefault will change if an item was selected
                  // First item from the List will be displayed
                  if (setDefaultcategoryname) {
                    category = snapshot.data!.docs[0].get('id');
                    debugPrint('setDefault categoryname: $category');
                  }
                  return DropdownButton(
                    isExpanded: false,
                    value: category,
                    items: snapshot.data!.docs.map((value) {
                      return DropdownMenuItem(
                        value: value.get('id'),
                        child: Text('${value.get('id')}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      debugPrint('selected onchange: $value');
                      setState(
                        () {
                          debugPrint('categoryname selected: $value');
                          // Selected value will be stored
                          category = value;
                          // Default dropdown value won't be displayed anymore
                          setDefaultcategoryname = false;
                          // Set subcategory to true to display first car from list
                          setDefaultsubcategory = true;
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
              child: category != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('subcategories')
                          .where('categoryname', isEqualTo: category)
                          .orderBy("subcategory").snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          debugPrint('snapshot status: ${snapshot.error}');
                          return Container(
                            child:
                            Text(
                                'snapshot empty category: $category subcategory: $categoryModel'),
                          );
                        }
                        if (setDefaultsubcategory) {
                          categoryModel = snapshot.data!.docs[0].get('subcategory');
                          debugPrint('setDefault subcategory: $categoryModel');
                        }
                        return DropdownButton(
                          isExpanded: false,
                          value: categoryModel,
                          items: snapshot.data!.docs.map((value) {
                            debugPrint('subcategory: ${value.get('subcategory')}');
                            return DropdownMenuItem(
                              value: value.get('subcategory'),
                              child: Text(
                                '${value.get('subcategory')}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            debugPrint('subcategory selected: $value');
                            setState(
                              () {
                                // Selected value will be stored
                                categoryModel = value;
                                // Default dropdown value won't be displayed anymore
                                setDefaultsubcategory = false;
                              },
                            );
                          },
                        );
                      },
                    )
                  : Container(
                      child: Text('category null category: $category subcategory: $categoryModel'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

