import 'package:flutter/material.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/models/product_item.dart';
import 'package:my_app/models/product_provider.dart';
import 'package:my_app/models/selectable_card.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  final String productItemId;

  const ProductGrid({required this.productItemId});


  // const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductListProvider>(context).products;
    final filteredProducts = products
        .where((product) =>
            product.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Expanded(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search Products',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Adjust as needed for columns
              crossAxisSpacing: 10.0, // Spacing between grid items
              mainAxisSpacing: 20.0, // Spacing between rows
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return SelectableCard(
                product: product,
                productItemId: widget.productItemId,
                // (Optional) Implement selection logic based on your requirements
                isSelected: false, // Modify selection logic if needed
                onSelectionChanged:
                    (isSelected) {}, // Modify selection logic if needed
                child: product != null // Check if product data exists
                    ? Container(
                        // Wrap child with Container for constraints
                        height: 100.0, // Set a fixed height
                        child: ProductItem(product: product, productItemId: widget.productItemId),
                      )
                    : Center(
                        child: Text(
                            'Loading...')), // Show loading indicator for missing data
              );
            },
          ),
        ],
      ),
    );
  }
}
