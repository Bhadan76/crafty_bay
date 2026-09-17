import 'package:crafty_bay/features/common/ui/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFiledWidget extends StatelessWidget {
  const SearchFiledWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () {
        Get.toNamed(SearchScreen.name);
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
