import 'dart:js';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:my_app/consts/consts.dart';
import 'package:my_app/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final String productItemId;

  const ProductItem({Key? key, required this.product, required this.productItemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Adjust width and height based on available space and desired aspect ratio
        final double itemWidth = maxWidth *
            0.5; // Adjust width as needed (e.g., 0.4 for 3 items per row)
        final double itemHeight =
            itemWidth * 1.2; // Adjust height based on aspect ratio

        return Container(
          width: itemWidth,
          height: itemHeight,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  product.imageUrl,
                  width: itemWidth, // Set image width to match item width
                  height: itemHeight * 0.6, // Adjust image height as needed
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                product.name,
                style: TextStyle(
                  fontSize: adjustFontSize(
                      maxWidth), // Adjust font size based on screen size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                '₱${product.price}', // Remove 'dd' prefix from price
                style: TextStyle(
                  fontSize:
                      adjustFontSize(maxWidth) * 0.8, // Adjust price font size
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered))
                          return Colors.blue.withOpacity(0.04);
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed))
                          return Colors.blue.withOpacity(0.12);
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    // Call the function to add the product to Firestore
                    _addProductToFirestore(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Product added'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text('Add Item'))
            ],
          ),
        );
      },
    );
  }

  double adjustFontSize(double maxWidth) {
    // Define logic to adjust font size based on screen size (optional)
    // You can use a minimum and maximum font size based on breakpoints
    return 16.0; // Default font size (optional)
  }

  // Function to add the product to Firestore
  Future<void> _addProductToFirestore(Product product) async {

    // Create new item map
      Map<String, dynamic> newItemMap = {
        'img': product.imageUrl,
        'product_id': product.id,
        'qty': 1,
        'title': product.name,
        'tprice': product.price,
        'vendor_id': 'aTeJ9DFCpcUX3gaHZ5A6I2axfgK2'
      };

      // Retrieve the document
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(productItemId).get();

      // Get the data
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      // Get the array and add new item
      List<dynamic> yourArray = List.from(data['orders']);
      yourArray.add(newItemMap);

      // Update the document with the modified data
      await FirebaseFirestore.instance.collection('orders').doc(productItemId).update({
        'orders': yourArray,
      });





    // // Reference to the Firestore collection
    // CollectionReference products = FirebaseFirestore.instance.collection('testing');

    // // Add the product to Firestore
    // products.add({
    //   'name': product.name,
    //   'price': product.price,
    // }).then((value) {
    //   // If successful, show a snackbar
    //   print("product added");
    // }).catchError((error) {
    //   // If an error occurs, show a snackbar with the error message
    //   // ScaffoldMessenger.of(context).showSnackBar(
    //   //   SnackBar(
    //   //     content: Text('Failed to add product: $error'),
    //   //     duration: Duration(seconds: 2),
    //   //   ),
    //   // );
    //   print("failed to add product");
    // });
  }
}



// import 'package:my_app/consts/consts.dart';
// import 'package:my_app/models/product.dart';


// class ProductItem extends StatelessWidget {
//   final Product product;

//   const ProductItem({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final maxWidth = constraints.maxWidth;
//         final maxHeight = constraints.maxHeight;

//         // Adjust width and height based on available space and desired aspect ratio
//         final double itemWidth = maxWidth *
//             0.5; // Adjust width as needed (e.g., 0.4 for 3 items per row)
//         final double itemHeight =
//             itemWidth * 1.2; // Adjust height based on aspect ratio

//         return Container(
//           width: itemWidth,
//           height: itemHeight,
//           padding: const EdgeInsets.all(10.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10.0),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 5.0,
//                 spreadRadius: 1.0,
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10.0),
//                 child: Image.network(
//                   product.imageUrl,
//                   width: itemWidth, // Set image width to match item width
//                   height: itemHeight * 0.6, // Adjust image height as needed
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               Text(
//                 product.name,
//                 style: TextStyle(
//                   fontSize: adjustFontSize(
//                       maxWidth), // Adjust font size based on screen size
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 5.0),
//               Text(
//                 'dd₱${product.price}',
//                 style: TextStyle(
//                   fontSize:
//                       adjustFontSize(maxWidth) * 0.8, // Adjust price font size
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 5.0),
//               TextButton(
//                 style: ButtonStyle(
//                   foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//                   overlayColor: MaterialStateProperty.resolveWith<Color?>(
//                     (Set<MaterialState> states) {
//                       if (states.contains(MaterialState.hovered))
//                         return Colors.blue.withOpacity(0.04);
//                       if (states.contains(MaterialState.focused) ||
//                           states.contains(MaterialState.pressed))
//                         return Colors.blue.withOpacity(0.12);
//                       return null; // Defer to the widget's default.
//                     },
//                   ),
//                 ),
//                 onPressed: () { },
//                 child: Text('Add Item')
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }

//   double adjustFontSize(double maxWidth) {
//     // Define logic to adjust font size based on screen size (optional)
//     // You can use a minimum and maximum font size based on breakpoints
//     return 16.0; // Default font size (optional)
//   }
// }
