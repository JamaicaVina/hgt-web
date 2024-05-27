import 'package:flutter/material.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/models/product_item.dart';

class SelectableCard extends StatefulWidget {
  final Product product; // The product data to be displayed
  final bool isSelected; // Initial selection state (optional)
  final ValueChanged<bool> onSelectionChanged; // Callback for selection changes
  final String productItemId;

  const SelectableCard({
    super.key,
    required this.product,
    required this.productItemId,
    required this.isSelected,
    required this.onSelectionChanged,
    required Widget child,
  });

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected; // Use initial selection state
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isSelected ? Colors.blue : null, // Change color on selection
      child: InkWell(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
            widget.onSelectionChanged(_isSelected); // Trigger callback
          });
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              border: _isSelected
                  ? Border.all(color: Colors.blue, width: 2.0)
                  : null, // Add border on selection
            ),
            child:
                ProductItem(product: widget.product, productItemId: widget.productItemId)), // Your product content
      ),
    );
  }
}
