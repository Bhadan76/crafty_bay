import 'package:crafty_bay/core/extensions/localization_extension.dart';
import 'package:flutter/material.dart';

class CreateReviewsScreen extends StatefulWidget {
  const CreateReviewsScreen({super.key});

  static const String name = '/create-review';

  @override
  State<CreateReviewsScreen> createState() => _CreateReviewsScreenState();
}

class _CreateReviewsScreenState extends State<CreateReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Reviews')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: SafeArea(
            child: Column(
              children: [
                TextFormField(
                  textInputAction: .next,
                  decoration: InputDecoration(
                    hintText: context.localization.first_name,
                  ),
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  textInputAction: .next,
                  decoration: InputDecoration(
                    hintText: context.localization.last_name,
                  ),
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  textInputAction: .next,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Write Review',
                  ),
                ),
                const SizedBox(height: 50,),
                ElevatedButton(onPressed: () {}, child: Text('Submit')),
            
              ],
            ),
          ),

        ),
      ),
    );
  }
}
