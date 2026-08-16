import 'package:crafty_bay/features/common/ui/widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key, required this.category});

  final String category;
  static const String name = '/products';

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: GridView.builder(
        itemCount: 30,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 0,
        ),
        itemBuilder: (context, index) {
          return const FittedBox(child: ProductCard());
        },
      ),
    );
  }
}
