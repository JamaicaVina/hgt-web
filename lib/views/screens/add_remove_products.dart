import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/controller/profile_controller.dart';
import 'package:my_app/views/screens/add_product.dart';
import 'package:my_app/views/screens/edit_product.dart';

class AddorRemoveProductsPage extends StatefulWidget {
  const AddorRemoveProductsPage({super.key});

  @override
  State<AddorRemoveProductsPage> createState() =>
      _AddorRemoveProductsPageState();
}

class _AddorRemoveProductsPageState extends State<AddorRemoveProductsPage> {
  final ref = FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

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
      body: Card(
        color: const Color.fromARGB(255, 4, 83, 158),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "add/remove product".toUpperCase(),
                    style: GoogleFonts.anton(
                      fontSize: 30,
                      letterSpacing: 5,
                      wordSpacing: 4,
                      color: const Color.fromARGB(255, 254, 240, 2),
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      size: 40,
                      color: Color.fromARGB(255, 4, 83, 158),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                child: StreamBuilder(
                    stream: ref,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SpinKitCircle(
                          color: Colors.red,
                        );
                      }
                      var size = MediaQuery.of(context).size;
                      final double itemHeight =
                          (size.height - kToolbarHeight - 24) / 5;
                      final double itemWidth = size.width / 2;
                      final documents = snapshot.data!.docs;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (itemWidth / itemHeight)),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final document = documents[index];
                          final data = document.data();

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        Column(
                                          children: [
                                            Text(
                                              'Name: ${data['p_name']}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                color: const Color.fromARGB(
                                                    255, 4, 83, 158),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Price: ₱${data['p_price']}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                color: const Color.fromARGB(
                                                    255, 4, 83, 158),
                                              ),
                                            ),
                                            // Text(
                                            //   '2Quantity: ${data['p_quantity']}',
                                            //   style: GoogleFonts.roboto(
                                            //     fontSize: 15,
                                            //     color: const Color.fromARGB(
                                            //         255, 4, 83, 158),
                                            //   ),
                                            // ),
                                          ],
                                        ),

/////////////////////////////////////////////////////////////////////////////////////////////////////
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                controller.docIdController
                                                    .text = data['document_id'];
                                                controller.nameController.text =
                                                    data['p_name'];
                                                controller.descripController
                                                    .text = data['p_desc'];
                                                controller.quantiController
                                                    .text = data['p_quantity'];
                                                controller.priController.text =
                                                    data['p_price'];
                                                Get.to(() => EditProductPage(
                                                    data: data));
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.yellow,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title:
                                                        const Text('Delete?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products')
                                                              .doc(document
                                                                  .reference.id)
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
                                                        child: const Text('No'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
///////////////////////////////////////////////////////////////////////////////////////////////////
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
