import 'package:flutter/Material.dart';

import '../../../../app/app_colors.dart';

class SearchSuggestionWidget extends StatelessWidget {
  late bool loading;
  late List<String> suggestions;
  late void Function(String title) onTap;

  SearchSuggestionWidget({
    required this.loading,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Colors.black26,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 280),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: loading
            ? const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Searching...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        )
            : suggestions.isEmpty
            ? const Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Text(
            'No suggestions found',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        )
            : ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: suggestions.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: Colors.grey.shade100,
            indent: 48,
          ),
          itemBuilder: (context, index) {
            final title = suggestions[index];
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onTap(title),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.north_west,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
