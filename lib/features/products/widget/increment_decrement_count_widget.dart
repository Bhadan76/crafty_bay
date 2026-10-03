import 'package:crafty_bay/features/products/ui/controller/product_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'count_button_widget.dart';

class IncrementDecrementCountWidget extends StatefulWidget {
  const IncrementDecrementCountWidget({
    super.key,
    required this.onChanged,
    this.initialValue = 1,
    this.maxValue,
  });
  final Function(int) onChanged;
  final int initialValue;

  /// Maximum count allowed. If null, falls back to the current
  /// product's stock (only safe inside the product details screen).
  /// Pass an explicit value when used from other screens (e.g. cart)
  /// to avoid coupling to ProductDetailsController.
  final int? maxValue;

  @override
  State<IncrementDecrementCountWidget> createState() => _IncrementDecrementCountWidgetState();
}

class _IncrementDecrementCountWidgetState extends State<IncrementDecrementCountWidget> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  /// Resolves the maximum allowed count.
  /// Priority: explicit maxValue → ProductDetailsController stock → unlimited.
  int? _resolveMax() {
    if (widget.maxValue != null) return widget.maxValue;
    if (Get.isRegistered<ProductDetailsController>()) {
      final controller = Get.find<ProductDetailsController>();
      final stock = controller.currentStock;
      return stock > 0 ? stock : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      children: [
        GestureDetector(
          onTap: () {
            if (count <= 1) return;
            setState(() {
              count--;
            });
            widget.onChanged(count);
          },
          child: CountButtonWidget(icon: Icons.remove),
        ),
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            final int? max = _resolveMax();
            if (max != null && count >= max) return;
            setState(() {
              count++;
            });
            widget.onChanged(count);
          },
          child: CountButtonWidget(icon: Icons.add),
        ),
      ],
    );
  }
}

