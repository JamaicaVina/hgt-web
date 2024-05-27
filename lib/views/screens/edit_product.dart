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
import 'package:my_app/controller/profile_controller.dart';
import 'package:my_app/widgets_common/snackbar.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

class EditProductPage extends StatefulWidget {
  final dynamic data;
  const EditProductPage({Key? key, this.data});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  var category;
  String categoryModel = ''; // Initialize with an empty string
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
    return productId!;
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
    var controller = Get.find<ProfileController>();

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
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: controller.nameController,
                              decoration: InputDecoration(
                                hintText: 'Product Names',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 4, 83, 158),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 4, 83, 158),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: controller.descripController,
                              decoration: InputDecoration(
                                hintText: 'Product Description',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 4, 83, 158),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 4, 83, 158),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: controller.quantController,
                              decoration: InputDecoration(
                                hintText: 'Quantity',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 4, 83, 158),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 4, 83, 158),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: TextField(
                                readOnly: true,
                                controller: controller.quantiController,
                                decoration: InputDecoration(
                                  hintText: 'Quantity',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 4, 83, 158),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 4, 83, 158),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: controller.priController,
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
                                    color: Color.fromARGB(255, 4, 83, 158),
                                  ),
                                ),
                              ),
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
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Text('No categories found');
                                        }

                                        if (setDefaultcategoryname) {
                                          category =
                                              snapshot.data!.docs[0].get('id');
                                          debugPrint(
                                              'setDefault categoryname: $category');
                                        }
                                        return DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Category',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 4, 83, 158),
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 4, 83, 158),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 4, 83, 158),
                                              ),
                                            ),
                                          ),
                                          isExpanded: false,
                                          value: category,
                                          items: snapshot.data!.docs
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value.get('id'),
                                              child: Text('${value.get('id')}'),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              category = value;
                                              // categoryModel = ''; // Reset subcategory value
                                              setDefaultcategoryname = false;
                                              setDefaultsubcategory = true; // Reset subcategory dropdown
                                            });
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
                                                .where('categoryname',
                                                    isEqualTo: category)
                                                .orderBy("subcategory")
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              }
                                              if (!snapshot.hasData ||
                                                  snapshot.data!.docs.isEmpty) {
                                                print(
                                                    'No subcategories found for category: $category');
                                                return Text(
                                                    'No subcategories found for this category');
                                              }

                                              // Extract subcategory names from snapshot
                                              List<String> subcategories = snapshot
                                                  .data!.docs
                                                  .map((doc) =>
                                                      doc['subcategory'] as String)
                                                  .toList();
                                              print(
                                                  'Subcategories found for category $category: $subcategories');

                                              // Check if categoryModel is valid for the current category selection
                                              if (!subcategories
                                                  .contains(categoryModel)) {
                                                categoryModel = subcategories
                                                        .isNotEmpty
                                                    ? subcategories.first
                                                    : '';
                                              }

                                              return DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                  hintText: 'Subcategory',
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 4, 83, 158),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 4, 83, 158),
                                                    ),
                                                  ),
                                                ),
                                                isExpanded: false,
                                                value: categoryModel,
                                                items: subcategories
                                                    .map((subcategory) {
                                                  return DropdownMenuItem(
                                                    value: subcategory,
                                                    child: Text(
                                                      subcategory,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    categoryModel =
                                                        value.toString(); // Convert value to string
                                                  });
                                                },
                                              );
                                            },
                                          )
                                        : Container(
                                            child: Text(
                                                'category: $category subcategory: $categoryModel'),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await controller.updateProducts(
                            docId: controller.docIdController.text,
                            name: controller.nameController.text,
                            descrip: controller.descripController.text,
                            quant: controller.quantController.text,
                            originalQuant: controller.quantiController.text,
                            pri: controller.priController.text,
                            categ: category,
                            subcateg: categoryModel);
                        VxToast.show(context, msg: "Updated");
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
                          'UPDATE PRODUCT',
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

