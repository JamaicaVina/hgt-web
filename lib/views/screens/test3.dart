import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/views/screens/test.dart';
import 'package:my_app/widgets_common/snackbar.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:math';

import 'package:uuid/uuid.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  var category, categoryModel;
  var setDefaultcategoryname = true, setDefaultsubcategory = true;

  TextEditingController productName = TextEditingController();
  TextEditingController productDesc = TextEditingController();
  TextEditingController productQuant = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController selectedSubCategory = TextEditingController();
  TextEditingController selectedCategory = TextEditingController();
  String _imageFile = '';
  String _productCategory = '';
  final db = FirebaseFirestore.instance;
  Uint8List? selectedImageInBytes;
  List<Widget> itemPhotosWidgetList = <Widget>[];

  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];

  List<String> downloadUrl = <String>[];

  bool uploading = false;

  addImage() {
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          height: 90.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              child: kIsWeb
                  ? Image.network(File(bytes.path).path)
                  : Image.file(
                      File(bytes.path),
                    ),
            ),
          ),
        ),
      ));
    }
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        addImage();
        photo!.clear();
      });
    }
  }

  upload() async {
    await uploadImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
    photo!.clear();
    showToast("Image Uploaded Successfully");
  }

  Future<String> uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? productId = const Uuid().v4();
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await uploadImageToStorage(pickedFile, productId);
    }
    return productId;
  }

  uploadImageToStorage(PickedFile? pickedFile, String productId) async {
    String? pId = const Uuid().v4();
    Reference reference =
        FirebaseStorage.instance.ref().child('Items/$productId/promo_$pId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();

    downloadUrl.add(value);
  }

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenheight = MediaQuery.of(context).size.height;
    return OKToast(
      child: Scaffold(
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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Card(
            color: const Color.fromARGB(255, 4, 83, 158),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: const Offset(0.0, 0.5),
                                      blurRadius: 30.0,
                                    )
                                  ]),
                              width: _screenwidth * 0.7,
                              height: 300.0,
                              child: Center(
                                child: itemPhotosWidgetList.isEmpty
                                    ? Center(
                                        child: MaterialButton(
                                          onPressed: pickPhotoFromGallery,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Center(
                                              child: Image.network(
                                                "https://static.thenounproject.com/png/3322766-200.png",
                                                height: 100.0,
                                                width: 100.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Wrap(
                                          spacing: 5.0,
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.spaceEvenly,
                                          runSpacing: 10.0,
                                          children: itemPhotosWidgetList,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: productName,
                              decoration: InputDecoration(
                                  hintText: 'Product Name',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 4, 83, 158),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 4, 83, 158),
                                      ))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: productDesc,
                              decoration: InputDecoration(
                                  hintText: 'Product Description',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 4, 83, 158),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 4, 83, 158)))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: productQuant,
                              decoration: InputDecoration(
                                  hintText: 'Quantity',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 4, 83, 158))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 4, 83, 158)))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: productPrice,
                              decoration: InputDecoration(
                                  hintText: 'Price',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 4, 83, 158),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 4, 83, 158),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 4, 83, 158)))),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
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
                                            hint: const Text(
                                              "Choose a Category",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
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





                                // Flexible(
                                //   child: TextField(
                                //     enabled: false,
                                //     controller: selectedCategory,
                                //     decoration: InputDecoration(
                                //         hintText:
                                //             'Select Category: ${selectedCategory.text}'
                                //                 .toUpperCase(),
                                //         enabledBorder: OutlineInputBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(30),
                                //           borderSide: const BorderSide(
                                //             color:
                                //                 Color.fromARGB(255, 4, 83, 158),
                                //           ),
                                //         ),
                                //         disabledBorder: OutlineInputBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(30),
                                //           borderSide: const BorderSide(
                                //             color:
                                //                 Color.fromARGB(255, 4, 83, 158),
                                //           ),
                                //         ),
                                //         focusedBorder: OutlineInputBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(30),
                                //             borderSide: const BorderSide(
                                //                 color: Color.fromARGB(
                                //                     255, 4, 83, 158)))),
                                //   ),
                                // ),
                                // Flexible(
                                //   child: TextField(
                                //     enabled: false,
                                //     controller: selectedSubCategory,
                                //     decoration: InputDecoration(
                                //         hintText:
                                //             'Select Sub-Category: ${selectedSubCategory.text}'
                                //                 .toUpperCase(),
                                //         enabledBorder: OutlineInputBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(30),
                                //           borderSide: const BorderSide(
                                //             color:
                                //                 Color.fromARGB(255, 4, 83, 158),
                                //           ),
                                //         ),
                                //         disabledBorder: OutlineInputBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(30),
                                //           borderSide: const BorderSide(
                                //             color:
                                //                 Color.fromARGB(255, 4, 83, 158),
                                //           ),
                                //         ),
                                //         focusedBorder: OutlineInputBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(30),
                                //             borderSide: const BorderSide(
                                //                 color: Color.fromARGB(
                                //                     255, 4, 83, 158)))),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('category')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Text('No data available');
                            }

                            List<QueryDocumentSnapshot> documents =
                                snapshot.data!.docs;
                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              shrinkWrap: true,
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                var documentData = documents[index].data()
                                    as Map<String, dynamic>;
                                var arrayData = documentData['categories'] as List<
                                    dynamic>; // Replace 'array_field' with your array field name.

                                return Card(
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${documentData['name']}'
                                                .toUpperCase(),
                                            style: GoogleFonts.roboto(
                                                fontSize: 20),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedCategory.text =
                                                    documentData['name'];
                                              });
                                              showToast(
                                                  '${documentData['name']} Selected!'
                                                      .toUpperCase());
                                            },
                                            child: const Text(
                                              'Select Category',
                                            ),
                                          ),
                                          ListTile(
                                              dense: true,
                                              subtitle: ListView.separated(
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const Divider(),
                                                shrinkWrap: true,
                                                itemCount: arrayData.length,
                                                itemBuilder:
                                                    (context, arrayIndex) {
                                                  int selectedIndex = 0;
                                                  var arrayElement =
                                                      arrayData[arrayIndex]
                                                          .toString();
                                                  return ListTile(
                                                    trailing: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedSubCategory
                                                                  .text =
                                                              arrayElement;
                                                        });
                                                        showToast(
                                                            '$arrayElement Selected!'
                                                                .toUpperCase());
                                                      },
                                                      child: const Text(
                                                        'Select Sub-Category',
                                                      ),
                                                    ),
                                                    dense: true,
                                                    title: Text(arrayElement
                                                        .toUpperCase()),
                                                  );
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool yourBooleanValue = true;
                        Random random = new Random();
                        int randomNumber = random.nextInt(6);
                        String randomNumberAsString = randomNumber.toString();
                        var arr = [];
                        var now = DateTime.now();
                        String monthKey = '${now.month}_${now.year}';
                        Map<String, dynamic> soldData = {monthKey: 0};
                        await upload();
                        try {
                          DocumentReference documentReference =
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .add({
                            'is_featured': yourBooleanValue,
                            'p_name': productName.text,
                            'p_price': productPrice.text,
                            'p_desc': productDesc.text,
                            'p_quantity': productQuant.text,
                            'p_rating': randomNumberAsString,
                            'p_category': category,
                            'p_subcategory': categoryModel,
                            // 'p_category': selectedCategory.text,
                            // 'p_subcategory': selectedSubCategory.text,
                            'p_wishlist': arr,
                            'p_seller': 'HGT',
                            'vendor_id': 'aTeJ9DFCpcUX3gaHZ5A6I2axfgK2',
                            'p_imgs': downloadUrl,
                            'p_sold': soldData,
                          });

                          String docID = documentReference.id;

                          await documentReference
                              .update({'document_id': docID});

                          productName.clear();
                          productPrice.clear();
                          productQuant.clear();
                          Navigator.pop(context);
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 254, 240, 2),
                        ),
                        child: Text(
                          'ADD PRODUCT',
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 4, 83, 158),
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
        ),
      ),
    );
  }
}
  
void fetchSubcategories(selectedCategory) {
  FirebaseFirestore.instance
      .collection('category')
      .doc(selectedCategory)
      .collection('categories')
      .snapshots()
      .listen((snapshot) {
    var subcategories = snapshot.docs;
    // TODO: Update the UI to display the subcategories.
    StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('category').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No data available');
    }

    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      shrinkWrap: true,
      itemCount: documents.length,
      itemBuilder: (context, index) {
        var documentData = documents[index].data() as Map<String, dynamic>;
        return Card(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '${documentData['name']}'.toUpperCase(),
                    style: GoogleFonts.roboto(fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      // setState(() {
                      //   selectedCategory.text = documentData['name'];
                      //   // Fetch and display subcategories for the selected category.
                      //   fetchSubcategories(selectedCategory.text);
                      // });
                      showToast('${documentData['name']} Selected!'.toUpperCase());
                    },
                    child: const Text('Select Category'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  },
);

  });
}

