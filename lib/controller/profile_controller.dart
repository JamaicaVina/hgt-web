
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController
{
  var profileImgPath = ''.obs;

  var profileImageLink = '';

  var isloading = false.obs;


  //textfield
  var docIdController = TextEditingController();
  var nameController = TextEditingController();
  var descripController = TextEditingController();
  var quantController = TextEditingController(text: "0");
  var quantiController = TextEditingController();
  var priController = TextEditingController();

  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();


  changeImage(context) async
  {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }


  uploadProfileImage() async
  {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }


  updateProducts({docId, name, descrip, quant, originalQuant, pri, categ, subcateg}) async
  {
    var store = firestore.collection(productsCollection).doc(docId);
    int quantity = int.parse(quant.toString()); // Convert quant to an integer
    int oriquantity = int.parse(originalQuant.toString()); // Convert quant to an integer

    int tot = oriquantity + quantity;
     // Convert tot to String
    String totString = tot.toString();

    store.set({
      'p_name': name,
      'p_desc': descrip,
      'p_quantity': totString,
      'p_price': pri,
      'p_category': categ,
      'p_subcategory': subcateg
    }, SetOptions(merge: true));
    isloading(false);
  }



  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error){
      print(error.toString());
    });
  }



}