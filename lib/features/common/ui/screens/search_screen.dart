import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/core/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/features/common/controllers/search_controller.dart'
    as custom_search;
import 'package:crafty_bay/features/common/ui/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/search_suggestion_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String name = '/search-screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchEditingController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final custom_search.SearchController _searchController =
      Get.find<custom_search.SearchController>();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments is String) {
        final initialQuery = Get.arguments as String;
        if (initialQuery.trim().isNotEmpty) {
          _searchEditingController.text = initialQuery;
          _searchController.setKeyword(initialQuery.trim());
          _searchController.refreshLoading();
        }
      } else if (_searchController.keyword.isNotEmpty) {
        _searchEditingController.text = _searchController.keyword;
      }
    });

    _scrollController.addListener(_onScroll);

    // Hide suggestions when focus is lost
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _searchController.hideSuggestions();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      _searchController.getSearchList();
    }
  }

  void _triggerSearch() {
    _focusNode.unfocus();
    final query = _searchEditingController.text.trim();
    if (query.isNotEmpty) {
      _searchController.hideSuggestions();
      _searchController.setKeyword(query);
      _searchController.refreshLoading();
    }
  }

  /// When user taps a suggestion — fill the field and search immediately
  void _onSuggestionTap(String title) {
    _searchEditingController.text = title;
    _searchController.hideSuggestions();
    _searchController.setKeyword(title);
    _searchController.refreshLoading();
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextField(
            controller: _searchEditingController,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _triggerSearch(),
            onChanged: (val) {
              setState(() {});
              _searchController.onSearchChanged(val);
            },
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchEditingController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchEditingController.clear();
                        _searchController.clearSearch();
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: _triggerSearch,
          ),
        ],
      ),
      body: GetBuilder<custom_search.SearchController>(
        builder: (controller) {
          return Stack(
            children: [
              // ── Main product list area ───────────────────────────────────
              _buildBody(controller),

              // ── Suggestion dropdown overlay ──────────────────────────────
              if (controller.showSuggestions)
                Positioned(
                  top: 0,
                  left: 8,
                  right: 8,
                  child: SearchSuggestionWidget(
                    loading: controller.suggestionLoading,
                    suggestions: controller.suggestions
                        .map((s) => s.title)
                        .toList(),
                    onTap: _onSuggestionTap,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(custom_search.SearchController controller) {
    if (controller.inProgress && controller.productList.isEmpty) {
      return const CenterCircularProgressIndicator();
    }

    if (controller.errorMessage != null && controller.productList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _triggerSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_searchEditingController.text.trim().isEmpty &&
        controller.productList.isEmpty &&
        !controller.inProgress) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Search CraftyBay Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type keyword above to discover amazing deals',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    if (controller.productList.isEmpty && !controller.inProgress) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied_rounded,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different keyword',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshLoading();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              controller: _scrollController,
              itemCount: controller.productList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return FittedBox(
                  child: ProductCard(
                    productListModel: controller.productList[index],
                  ),
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: controller.isLoadingMore,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: LinearProgressIndicator(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
