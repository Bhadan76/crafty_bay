import 'package:flutter/Material.dart';

class paymentCart extends StatelessWidget {
  const paymentCart({
    super.key, required this.image, required this.onTap,
  });
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              image,
              height: 100,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}