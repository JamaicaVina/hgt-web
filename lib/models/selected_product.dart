import 'package:my_app/consts/consts.dart';
import 'package:my_app/models/product.dart';

class SelectedProduct {
  final Product product;
  int quantity;

  SelectedProduct({
    required this.product,
    required this.quantity,
  });
}
