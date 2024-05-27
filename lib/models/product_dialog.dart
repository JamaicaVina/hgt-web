import 'package:my_app/consts/consts.dart';
import 'package:my_app/models/product_grid.dart';
import 'package:my_app/models/product_provider.dart';
import 'package:provider/provider.dart';

class ProductDialog extends StatefulWidget {
  final String productItemId;

  // ProductDialog({required this.productItemId});

  const ProductDialog({super.key, required this.productItemId});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  List<bool> _selectedProducts = [];
  @override
  void initState() {
    super.initState();
    final products =
        Provider.of<ProductListProvider>(context, listen: false).products;
    _selectedProducts = List.filled(
        products.length, false); // Initialize with false for each product
  }

  void updateSelection(int index, bool isSelected) {
    setState(() {
      _selectedProducts[index] = isSelected;
      // Handle selection logic here (e.g., display selected products)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Provider.of<ProductListProvider>(context).isLoading
              ? const Center(child: CircularProgressIndicator())
              : (Provider.of<ProductListProvider>(context)
                      .errorMessage
                      .isNotEmpty)
                  ? Center(
                      child: Text(Provider.of<ProductListProvider>(context)
                          .errorMessage))
                  // : ProductGrid(productItemId2: productItemId),
                  : ProductGrid(productItemId: widget.productItemId),
        ),
      ),
    );
  }
}
