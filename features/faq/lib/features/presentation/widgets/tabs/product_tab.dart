import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:faq/features/presentation/widgets/product_list_tile.dart';
import 'package:flutter/material.dart';
// ignore_for_file: must_be_immutable
class ProductTab extends StatefulWidget {
  List<ProductTypes> productTypes;
  ProductTab(this.productTypes, {super.key});

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MFGradientBackground(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 35),
          itemCount: widget.productTypes.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ProductListTile(widget.productTypes[index], index);
          },
        ),
      ),
    );
  }
}
