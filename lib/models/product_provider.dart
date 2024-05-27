import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/models/product.dart';

class ProductListProvider extends ChangeNotifier {
  List<Product> products = [];
  bool isLoading = false; // Flag for loading state
  String errorMessage = ''; // To store any errors

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String productsCollection =
      'products'; // Replace with your collection name

  // Fetch products from Firestore
  Future<void> getProducts() async {
    isLoading = true;
    errorMessage = ''; // Clear any previous errors
    notifyListeners();

    try {
      final productCollection = firestore.collection(productsCollection);
      final snapshot = await productCollection.get();
      products =
          snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } on FirebaseException catch (error) {
      errorMessage = error.message ?? 'Failed to load products.';
    } catch (error) {
      errorMessage = 'An error occurred: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
