import 'package:my_app/consts/consts.dart';
import 'package:my_app/models/selected_product.dart';

class SelectedProductList extends StatelessWidget {
  final List<SelectedProduct> selectedProducts;

  const SelectedProductList({super.key, required this.selectedProducts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Prevent excessive scrolling
      itemCount: selectedProducts.length,
      itemBuilder: (context, index) {
        final selectedProduct = selectedProducts[index];
        return ListTile(
          title: Text(selectedProduct.product.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // Compact trailing widgets
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  // Handle decrementing quantity (optional)
                  // Update quantity in _selectedProducts list and call setState()
                },
              ),
              Text('${selectedProduct.quantity}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Handle incrementing quantity (optional)
                  // Update quantity in _selectedProducts list and call setState()
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
