import 'dart:io';
import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uuid/uuid.dart';

class AddRemovePromo extends StatefulWidget {
  const AddRemovePromo({Key? key}) : super(key: key);

  @override
  _AddRemovePromoState createState() => _AddRemovePromoState();
}

class _AddRemovePromoState extends State<AddRemovePromo> {
  List<Widget> itemPhotosWidgetList = <Widget>[];

  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];

  List<String> downloadUrl = <String>[];

  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenheight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 480) {
        return displayPhoneUploadFormScreen(_screenwidth, _screenheight);
      } else {
        return displayWebUploadFormScreen(_screenwidth, _screenheight);
      }
    });
  }

  displayPhoneUploadFormScreen(_screenwidth, _screenheight) {
    return Container();
  }

  displayWebUploadFormScreen(_screenwidth, _screenheight) {
    return OKToast(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _screenheight,
        child: SingleChildScrollView(
          child: Card(
            color: const Color.fromARGB(255, 4, 83, 158),
            child: Column(
              children: [
                const SizedBox(
                  height: 100.0,
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50.0,
                        left: 100.0,
                        right: 100.0,
                      ),
                      child: ElevatedButton(
                          onPressed: uploading
                              ? null
                              : () async {
                                  await upload();
                                  await FirebaseFirestore.instance
                                      .collection('promos')
                                      .doc()
                                      .set({
                                    'current_promos': downloadUrl,
                                  });
                                },
                          child: uploading
                              ? const SizedBox(
                                  child: CircularProgressIndicator(),
                                  height: 15.0,
                                )
                              : const Text(
                                  "Add",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('promos')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text('No data available');
                    }

                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var documentData =
                            documents[index].data() as Map<String, dynamic>;
                        var arrayData = documentData['current_promos'] as List<
                            dynamic>; // Replace 'array_field' with your array field name.

                        return SizedBox(
                          child: Card(
                            child: ListTile(
                              leading: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('promos')
                                                .doc(documents[index]
                                                    .reference
                                                    .id)
                                                .delete();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
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
                              dense: true,
                              subtitle: ListView.builder(
                                shrinkWrap: true,
                                itemCount: arrayData.length,
                                itemBuilder: (context, arrayIndex) {
                                  var arrayElement =
                                      arrayData[arrayIndex].toString();
                                  return ListTile(
                                    dense: true,
                                    title: Container(
                                      width: _screenwidth * 0.7,
                                      height: 300.0,
                                      child: Image.network(
                                        arrayElement,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
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
          ),
        ),
      ),
    ));
  }

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
}
