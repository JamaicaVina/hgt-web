import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController addCategory = TextEditingController();
  final TextEditingController addSubCategory = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 83, 158),
        toolbarHeight: 120,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: const Image(
                  image: ExactAssetImage('assets/images/hgt_logo.png'),
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Harry Guantero Trading".toUpperCase(),
                  style: GoogleFonts.anton(
                    fontSize: 30,
                    letterSpacing: 10,
                    wordSpacing: 4,
                    color: const Color.fromARGB(255, 254, 240, 2),
                  ),
                ),
                Text(
                  "M. Revil St. Corner Barrientos St., Poblacion 2, Oroquieta City Misamis Occidental, Philippines",
                  style: GoogleFonts.anton(
                    fontSize: 15,
                    wordSpacing: 4,
                    color: const Color.fromARGB(255, 254, 240, 2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: const Color.fromARGB(255, 4, 83, 158),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories".toUpperCase(),
                      style: GoogleFonts.anton(
                        fontSize: 30,
                        letterSpacing: 5,
                        wordSpacing: 4,
                        color: const Color.fromARGB(255, 254, 240, 2),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: SizedBox(
                                  height: 450,
                                  width: 450,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                            controller: addCategory,
                                            decoration: InputDecoration(
                                                hintText: 'Category Name',

                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    borderSide: const BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 31, 31, 176))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    31,
                                                                    31,
                                                                    176)))),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              FirebaseFirestore.instance
                                                  .collection('category')
                                                  .doc(addCategory.text
                                                      .replaceAll(' ', '_'))
                                                  .set({
                                                'name':
                                                    addCategory.text.toString(),
                                                'categories':
                                                    FieldValue.arrayUnion([]),
                                                'id': addCategory.text
                                                    .replaceAll(' ', '_')
                                                    .toString(),
                                              });
                                              addCategory.clear();
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 200,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color.fromARGB(
                                                    255, 31, 31, 176),
                                              ),
                                              child: Text(
                                                'Add Category',
                                                style: GoogleFonts.roboto(
                                                  color: const Color.fromARGB(
                                                      255, 252, 255, 58),
                                                  letterSpacing: 3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(
                        Icons.add,
                        size: 40,
                        color: Color.fromARGB(255, 4, 83, 158),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('category')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(child: Text('No data available')),
                        ],
                      );
                    }
                    var size = MediaQuery.of(context).size;
                    final double itemHeight =
                        (size.height - kToolbarHeight - 50) / 2;
                    final double itemWidth = size.width / 2;
                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: (itemWidth / itemHeight),
                        mainAxisSpacing: 5,
                      ),
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var documentData =
                            documents[index].data() as Map<String, dynamic>;
                        var arrayData = documentData['categories'] as List<
                            dynamic>; // Replace 'array_field' with your array field name.

                        String docID = documentData['id'];
                        return SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Card(
                                        color: const Color.fromARGB(
                                            255, 4, 83, 158),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  const Divider(),
                                                                  Text(
                                                                    'Sub-categories: ',
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          252,
                                                                          255,
                                                                          58),
                                                                      letterSpacing:
                                                                          3,
                                                                    ),
                                                                  ),
                                                                  Card(
                                                                    child: ListView
                                                                        .separated(
                                                                      separatorBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return const Divider();
                                                                      },
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          arrayData
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              arrayIndex) {
                                                                        var arrayElement =
                                                                            arrayData[arrayIndex].toString();
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return Dialog(
                                                                                    child: Card(
                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                      child: SizedBox(
                                                                                        child: Column(
                                                                                          children: [
                                                                                            StreamBuilder(
                                                                                              stream: FirebaseFirestore.instance.collection('products').where('p_subcategory', isEqualTo: '${arrayElement}').snapshots(),
                                                                                              builder: (context, snapshot) {
                                                                                                if (!snapshot.hasData) {
                                                                                                  return const SpinKitCircle(
                                                                                                    color: Colors.red,
                                                                                                  );
                                                                                                }
                                                                                                final documents = snapshot.data!.docs;
                                                                                                return ListView.builder(
                                                                                                  scrollDirection: Axis.vertical,
                                                                                                  shrinkWrap: true,
                                                                                                  itemCount: documents.length,
                                                                                                  itemBuilder: (context, index) {
                                                                                                    final document = documents[index];
                                                                                                    final data = document.data();

                                                                                                    return Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Card(
                                                                                                        child: ListTile(
                                                                                                          trailing: IconButton(
                                                                                                            onPressed: () {
                                                                                                              FirebaseFirestore.instance.collection('products').doc(document.reference.id).delete();
                                                                                                            },
                                                                                                            icon: const Icon(
                                                                                                              Icons.delete,
                                                                                                              color: Colors.red,
                                                                                                            ),
                                                                                                          ),
                                                                                                          title: Row(
                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                height: 80,
                                                                                                                width: 80,
                                                                                                                child: Card(
                                                                                                                  child: Image.network(
                                                                                                                    '${data['p_imgs'][0]}',
                                                                                                                    scale: 2,
                                                                                                                    fit: BoxFit.cover,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                'Name: ${data['p_name']}',
                                                                                                                style: GoogleFonts.roboto(
                                                                                                                  fontSize: 15,
                                                                                                                  color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                'Price: ₱${data['p_price']}',
                                                                                                                style: GoogleFonts.roboto(
                                                                                                                  fontSize: 15,
                                                                                                                  color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                'Quantity: ${data['p_quantity']}',
                                                                                                                style: GoogleFonts.roboto(
                                                                                                                  fontSize: 15,
                                                                                                                  color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                });
                                                                          },
                                                                          child:
                                                                              ListTile(
                                                                            trailing:
                                                                                IconButton(
                                                                              icon: const Icon(Icons.delete),
                                                                              onPressed: () {
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: const Text('Remove Category?'),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () async {
                                                                                            await FirebaseFirestore.instance.collection('category').doc('${docID}').update({
                                                                                              'categories': FieldValue.arrayRemove([
                                                                                                '${arrayElement}'
                                                                                              ])
                                                                                            }).then(
                                                                                              (value) => Navigator.pop(context),
                                                                                            );
                                                                                          },
                                                                                          child: const Text('Yes'),
                                                                                        ),
                                                                                        TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: const Text('No')),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),
                                                                            dense:
                                                                                true,
                                                                            title:
                                                                                Text(
                                                                              '${arrayElement}'.toUpperCase(),
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 31, 31, 176),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(),
                                                    ElevatedButton(
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                          Color.fromARGB(255,
                                                              252, 255, 58),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        await showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Dialog(
                                                                child: SizedBox(
                                                                  height: 450,
                                                                  width: 450,
                                                                  child: Card(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          TextField(
                                                                            controller:
                                                                                addSubCategory,
                                                                            decoration: InputDecoration(
                                                                                hintText: 'Category Name',
                                                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color.fromARGB(255, 31, 31, 176))),
                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color.fromARGB(255, 31, 31, 176)))),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              await FirebaseFirestore.instance.collection('category').doc('${docID}').update({
                                                                                'categories': FieldValue.arrayUnion([
                                                                                  addSubCategory.text.toString(),
                                                                                ])
                                                                              });
                                                                              addSubCategory.clear();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 50,
                                                                              width: 200,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                color: const Color.fromARGB(255, 31, 31, 176),
                                                                              ),
                                                                              child: Text(
                                                                                'Add Sub-Category',
                                                                                style: GoogleFonts.roboto(
                                                                                  color: const Color.fromARGB(255, 252, 255, 58),
                                                                                  letterSpacing: 3,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: Text(
                                                        'Add Sub-Category',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 31, 31, 176),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Container(
                                        child: Text(
                                          '${documentData['name']}'
                                              .toUpperCase(),
                                          style: GoogleFonts.roboto(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 4, 83, 158)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 4, 83, 158),
                                      ),
                                      child: ButtonBar(
                                        children: [









                                      
                                          TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      child: Card(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 4, 83, 158),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              SizedBox(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  const Divider(),
                                                                                  Text(
                                                                                    'Sub-categories: ',
                                                                                    style: GoogleFonts.roboto(
                                                                                      color: const Color.fromARGB(255, 252, 255, 58),
                                                                                      letterSpacing: 3,
                                                                                    ),
                                                                                  ),
                                                                                  Card(
                                                                                    child: ListView.separated(
                                                                                      separatorBuilder: (context, index) {
                                                                                        return const Divider();
                                                                                      },
                                                                                      shrinkWrap: true,
                                                                                      itemCount: arrayData.length,
                                                                                      itemBuilder: (context, arrayIndex) {
                                                                                        var arrayElement = arrayData[arrayIndex].toString();
                                                                                        return GestureDetector(
                                                                                          onTap: () {
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return Dialog(
                                                                                                    child: Card(
                                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                      child: SizedBox(
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            StreamBuilder(
                                                                                                                stream: FirebaseFirestore.instance.collection('products').where('p_subcategory', isEqualTo: '${arrayElement}').snapshots(),
                                                                                                                builder: (context, snapshot) {
                                                                                                                  if (!snapshot.hasData) {
                                                                                                                    return const SpinKitCircle(
                                                                                                                      color: Colors.red,
                                                                                                                    );
                                                                                                                  }
                                                                                                                  final documents = snapshot.data!.docs;
                                                                                                                  return ListView.builder(
                                                                                                                      scrollDirection: Axis.vertical,
                                                                                                                      shrinkWrap: true,
                                                                                                                      itemCount: documents.length,
                                                                                                                      itemBuilder: (context, index) {
                                                                                                                        final document = documents[index];
                                                                                                                        final data = document.data();

                                                                                                                        return Padding(
                                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                                          child: Card(
                                                                                                                            child: ListTile(
                                                                                                                              trailing: IconButton(
                                                                                                                                onPressed: () {
                                                                                                                                  FirebaseFirestore.instance.collection('products').doc(document.reference.id).delete();
                                                                                                                                },
                                                                                                                                icon: const Icon(
                                                                                                                                  Icons.delete,
                                                                                                                                  color: Colors.red,
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              title: Row(
                                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                                                children: [
                                                                                                                                  SizedBox(
                                                                                                                                    height: 80,
                                                                                                                                    width: 80,
                                                                                                                                    child: Card(
                                                                                                                                      child: Image.network(
                                                                                                                                        '${data['p_imgs'][0]}',
                                                                                                                                        scale: 2,
                                                                                                                                        fit: BoxFit.cover,
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    'Name: ${data['p_name']}',
                                                                                                                                    style: GoogleFonts.roboto(
                                                                                                                                      fontSize: 15,
                                                                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    'Price: ₱${data['p_price']}',
                                                                                                                                    style: GoogleFonts.roboto(
                                                                                                                                      fontSize: 15,
                                                                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    'Quantity: ${data['p_quantity']}',
                                                                                                                                    style: GoogleFonts.roboto(
                                                                                                                                      fontSize: 15,
                                                                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        );
                                                                                                                      });
                                                                                                                })
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                });
                                                                                          },
                                                                                          child: ListTile(
                                                                                            trailing: IconButton(
                                                                                              icon: const Icon(Icons.delete),
                                                                                              onPressed: () {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return AlertDialog(
                                                                                                      title: const Text('Remove Category?'),
                                                                                                      actions: [
                                                                                                        TextButton(
                                                                                                          onPressed: () async {
                                                                                                            await FirebaseFirestore.instance.collection('category').doc('${docID}').update({
                                                                                                              'categories': FieldValue.arrayRemove(['${arrayElement}'])
                                                                                                            }).then(
                                                                                                              (value) => Navigator.pop(context),
                                                                                                            );
                                                                                                          },
                                                                                                          child: const Text('Yes'),
                                                                                                        ),
                                                                                                        TextButton(
                                                                                                            onPressed: () {
                                                                                                              Navigator.pop(context);
                                                                                                            },
                                                                                                            child: const Text('No')),
                                                                                                      ],
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                            dense: true,
                                                                                            title: Text(
                                                                                              '${arrayElement}'.toUpperCase(),
                                                                                              style: GoogleFonts.roboto(
                                                                                                color: const Color.fromARGB(255, 31, 31, 176),
                                                                                                letterSpacing: 3,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const Divider(),
                                                                    ElevatedButton(
                                                                      style:
                                                                          const ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStatePropertyAll(
                                                                          Color.fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return Dialog(
                                                                                child: SizedBox(
                                                                                  height: 450,
                                                                                  width: 450,
                                                                                  child: Card(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          TextField(
                                                                                            controller: addSubCategory,
                                                                                            decoration: InputDecoration(hintText: 'Category Name', enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color.fromARGB(255, 31, 31, 176))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color.fromARGB(255, 31, 31, 176)))),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 20,
                                                                                          ),
                                                                                          GestureDetector(
                                                                                            onTap: () async {
                                                                                              await FirebaseFirestore.instance.collection('category').doc('${docID}').update({
                                                                                                'categories': FieldValue.arrayUnion([
                                                                                                  addSubCategory.text.toString(),
                                                                                                ])
                                                                                              });
                                                                                              addSubCategory.clear();
                                                                                            },
                                                                                            child: Container(
                                                                                              height: 50,
                                                                                              width: 200,
                                                                                              alignment: Alignment.center,
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                                color: const Color.fromARGB(255, 31, 31, 176),
                                                                                              ),
                                                                                              child: Text(
                                                                                                'Add Sub-Category',
                                                                                                style: GoogleFonts.roboto(
                                                                                                  color: const Color.fromARGB(255, 252, 255, 58),
                                                                                                  letterSpacing: 3,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Add Sub-Category',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              31,
                                                                              31,
                                                                              176),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text(
                                              '',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 252, 255, 58),
                                              ),
                                            ),
                                          ),


                             
//                          TextButton(
//   child: const Text(
//     'Edit',
//     style: TextStyle(
//       color: Colors.yellow, // You can change the color to match your UI
//     ),
//   ),
//   onPressed: () {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String categoryName = ''; // Initialize category name
//         return AlertDialog(
//           title: const Text('Edit Category'),
//           content: TextField(
//             onChanged: (value) {
//               categoryName = value; // Update category name as user types
//             },
//             decoration: InputDecoration(hintText: 'New Category Name'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 // Update category name in Firestore
//                 await FirebaseFirestore.instance
//                     .collection('category')
//                     .doc('${docID}')
//                     .update({'name': categoryName})
//                     .then((value) {
//                   Navigator.pop(context); // Close dialog on success
//                 }).catchError((error) {
//                   // Handle error if any
//                   print("Failed to update category: $error");
//                 });
                
//                 // Update category name in Firestore
//                 await FirebaseFirestore.instance
//                     .collection('category')
//                     .doc('${docID}')
//                     .update({'category': categoryName})
//                     .then((value) {
//                   Navigator.pop(context); // Close dialog on success
//                 }).catchError((error) {
//                   // Handle error if any
//                   print("Failed to update category: $error");
//                 });
//               },
              
//               child: const Text('Save'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog without saving
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   },
// ),




                              
                                      //details
                                      TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      child: Card(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 4, 83, 158),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              SizedBox(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  const Divider(),
                                                                                  Text(
                                                                                    'Sub-categories: ',
                                                                                    style: GoogleFonts.roboto(
                                                                                      color: const Color.fromARGB(255, 252, 255, 58),
                                                                                      letterSpacing: 3,
                                                                                    ),
                                                                                  ),
                                                                                  Card(
                                                                                    child: ListView.separated(
                                                                                      separatorBuilder: (context, index) {
                                                                                        return const Divider();
                                                                                      },
                                                                                      shrinkWrap: true,
                                                                                      itemCount: arrayData.length,
                                                                                      itemBuilder: (context, arrayIndex) {
                                                                                        var arrayElement = arrayData[arrayIndex].toString();
                                                                                        return GestureDetector(
                                                                                          onTap: () {
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return Dialog(
                                                                                                    child: Card(
                                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                      child: SizedBox(
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            StreamBuilder(
                                                                                                                stream: FirebaseFirestore.instance.collection('products').where('p_subcategory', isEqualTo: '${arrayElement}').snapshots(),
                                                                                                                builder: (context, snapshot) {
                                                                                                                  if (!snapshot.hasData) {
                                                                                                                    return const SpinKitCircle(
                                                                                                                      color: Colors.red,
                                                                                                                    );
                                                                                                                  }
                                                                                                                  final documents = snapshot.data!.docs;
                                                                                                                  return ListView.builder(
                                                                                                                      scrollDirection: Axis.vertical,
                                                                                                                      shrinkWrap: true,
                                                                                                                      itemCount: documents.length,
                                                                                                                      itemBuilder: (context, index) {
                                                                                                                        final document = documents[index];
                                                                                                                        final data = document.data();

                                                                                                                        return Padding(
                                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                                          child: Card(
                                                                                                                            child: ListTile(
                                                                                                                              trailing: IconButton(
                                                                                                                                onPressed: () {
                                                                                                                                  FirebaseFirestore.instance.collection('products').doc(document.reference.id).delete();
                                                                                                                                },
                                                                                                                                icon: const Icon(
                                                                                                                                  Icons.delete,
                                                                                                                                  color: Colors.red,
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              title: Row(
                                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                                                children: [
                                                                                                                                  SizedBox(
                                                                                                                                    height: 80,
                                                                                                                                    width: 80,
                                                                                                                                    child: Card(
                                                                                                                                      child: Image.network(
                                                                                                                                        '${data['p_imgs'][0]}',
                                                                                                                                        scale: 2,
                                                                                                                                        fit: BoxFit.cover,
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    'Name: ${data['p_name']}',
                                                                                                                                    style: GoogleFonts.roboto(
                                                                                                                                      fontSize: 15,
                                                                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    'Price: ₱${data['p_price']}',
                                                                                                                                    style: GoogleFonts.roboto(
                                                                                                                                      fontSize: 15,
                                                                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  Text(
                                                                                                                                    'Quantity: ${data['p_quantity']}',
                                                                                                                                    style: GoogleFonts.roboto(
                                                                                                                                      fontSize: 15,
                                                                                                                                      color: const Color.fromARGB(255, 4, 83, 158),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        );
                                                                                                                      });
                                                                                                                })
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                });
                                                                                          },
                                                                                          child: ListTile(
                                                                                            trailing: IconButton(
                                                                                              icon: const Icon(Icons.delete),
                                                                                              onPressed: () {
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return AlertDialog(
                                                                                                      title: const Text('Remove Category?'),
                                                                                                      actions: [
                                                                                                        TextButton(
                                                                                                          onPressed: () async {
                                                                                                            await FirebaseFirestore.instance.collection('category').doc('${docID}').update({
                                                                                                              'categories': FieldValue.arrayRemove(['${arrayElement}'])
                                                                                                            }).then(
                                                                                                              (value) => Navigator.pop(context),
                                                                                                            );
                                                                                                          },
                                                                                                          child: const Text('Yes'),
                                                                                                        ),
                                                                                                        TextButton(
                                                                                                            onPressed: () {
                                                                                                              Navigator.pop(context);
                                                                                                            },
                                                                                                            child: const Text('No')),
                                                                                                      ],
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                            dense: true,
                                                                                            title: Text(
                                                                                              '${arrayElement}'.toUpperCase(),
                                                                                              style: GoogleFonts.roboto(
                                                                                                color: const Color.fromARGB(255, 31, 31, 176),
                                                                                                letterSpacing: 3,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const Divider(),
                                                                    ElevatedButton(
                                                                      style:
                                                                          const ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStatePropertyAll(
                                                                          Color.fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return Dialog(
                                                                                child: SizedBox(
                                                                                  height: 450,
                                                                                  width: 450,
                                                                                  child: Card(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          TextField(
                                                                                            controller: addSubCategory,
                                                                                            decoration: InputDecoration(hintText: 'Subcategory Name', enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color.fromARGB(255, 31, 31, 176))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color.fromARGB(255, 31, 31, 176)))),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 20,
                                                                                          ),
                                                                                          GestureDetector(
                                                                                            onTap: () async {
                                                                                              await FirebaseFirestore.instance.collection('category').doc('${docID}').update({
                                                                                                'categories': FieldValue.arrayUnion([
                                                                                                  addSubCategory.text.toString(),
                                                                                                ])
                                                                                              });
                                                                                              // addSubCategory.clear();

                                                                                              

                                                                                              try {
                                                                                                await FirebaseFirestore.instance.collection('subcategories').add({
                                                                                                  'categoryname': docID,
                                                                                                  'subcategory': addSubCategory.text,
                                                                                                });
                                                                                                print("test2");
                                                                                              } catch (e) {
                                                                                                print(e.toString());
                                                                                              }
                                                                                              addSubCategory.clear();
                                                                                            },
                                                                                            child: Container(
                                                                                              height: 50,
                                                                                              width: 200,
                                                                                              alignment: Alignment.center,
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                                color: const Color.fromARGB(255, 31, 31, 176),
                                                                                              ),
                                                                                              child: Text(
                                                                                                'Add Sub-Category',
                                                                                                style: GoogleFonts.roboto(
                                                                                                  color: const Color.fromARGB(255, 252, 255, 58),
                                                                                                  letterSpacing: 3,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Add Sub-Category',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              31,
                                                                              31,
                                                                              176),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text(
                                              'Details',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 252, 255, 58),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            child: const Text(
                                              'Remove',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 252, 255, 58),
                                              ),
                                            ),
                                             
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Remove Category?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'category')
                                                              .doc('${docID}')
                                                              .delete();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('No')),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

