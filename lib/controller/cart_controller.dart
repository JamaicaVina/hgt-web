import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/controller/home_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController
{
  var totlalP = 0.obs;

  //text controllers for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();


  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];



  calculate(data)
  {
    totlalP.value = 0;
    for(var i=0; i < data.length; i++)
    {
      totlalP.value = totlalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index)
  {
    paymentIndex.value = index;
  }


  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {

    await getProductDetails();


    await firestore.collection(ordersCollection).doc().set({
      'order_code': "23232333",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': postalcodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products)
    });

    // await firestore.collection(ordersCollection).doc().set({
    //   'order_by': currentUser!.uid,
    //   'order_by_name': Get.find<HomeController>().username,
    //   'order_by_email': currentUser!.email,
    //   'order_by_address': addressController.text,
    //   'order_by_state': stateController.text,
    //   'order_by_city': cityController.text,
    //   'order_by_phone': phoneController.text,
    //   'order_by_postalcode': postalcodeController.text,
    //   'shipping_method': "Home Delivery",
    //   'payment_method': orderPaymentMethod,
    //   'order_placed': true,
    //   'total_amount': totalAmount,
    //   'orders': FieldValue.arrayUnion(products)
    // });
  }

  getProductDetails()
  {
    products.clear();
    for(var i = 0; i < productSnapshot.length; i++)
    {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
    }
    print(products);
  }


}