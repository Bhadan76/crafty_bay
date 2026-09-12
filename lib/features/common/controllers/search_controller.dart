import 'dart:async';

import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/common/data/model/product_list_model.dart';
import 'package:crafty_bay/features/common/data/model/search_suggestion_model.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  bool _inProgress = false;
  bool _isLoadingMore = false;
  final int _countData = 10;
  int _currentPage = 1;
  int? _totalPages;
  String _keyword = '';

  String? _errorMessage;
  List<ProductListModel> _productList = [];

  // ── Suggestion state ──────────────────────────────────────────────────────
  bool _suggestionLoading = false;
  List<SearchSuggestionModel> _suggestions = [];
  bool _showSuggestions = false;
  Timer? _debounceTimer;

  bool get inProgress => _inProgress;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<ProductListModel> get productList => _productList;
  String get keyword => _keyword;

  bool get suggestionLoading => _suggestionLoading;
  List<SearchSuggestionModel> get suggestions => _suggestions;
  bool get showSuggestions => _showSuggestions;

  void setKeyword(String keyword) {
    _keyword = keyword;
  }

  void clearSearch() {
    _keyword = '';
    _productList.clear();
    _currentPage = 1;
    _totalPages = null;
    _errorMessage = null;
    hideSuggestions();
    update();
  }

  // ── Suggestion Methods ────────────────────────────────────────────────────

  /// Called on every keystroke — debounced 400ms
  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      _suggestions.clear();
      _showSuggestions = false;
      update();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _fetchSuggestions(trimmed);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    _suggestionLoading = true;
    _showSuggestions = true;
    update();

    final NetworkResponse response =
        await Get.find<NetworkCaller>().getRequest(
      url: AppUrls.searchSuggestionsUrl,
      queryParameters: {'keyword': query, 'limit': 8},
    );

    if (response.isSuccess) {
      final data = response.responseData;
      if (data != null && data['data'] != null) {
        _suggestions = (data['data'] as List)
            .map((item) =>
                SearchSuggestionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _suggestions = [];
      }
    } else {
      _suggestions = [];
    }

    _suggestionLoading = false;
    update();
  }

  void hideSuggestions() {
    _debounceTimer?.cancel();
    _showSuggestions = false;
    _suggestions.clear();
    update();
  }

  // ── Product Search (full list) ────────────────────────────────────────────

  Future<bool> getSearchList() async {
    if (_keyword.trim().isEmpty) {
      _productList.clear();
      update();
      return false;
    }

    if (_totalPages != null && _currentPage > _totalPages!) {
      return false;
    }

    // Avoid multiple concurrent requests
    if (_inProgress || _isLoadingMore) return false;

    if (_currentPage == 1) {
      _inProgress = true;
    } else {
      _isLoadingMore = true;
    }

    update();

    final NetworkResponse response =
        await Get.find<NetworkCaller>().getRequest(
      url: AppUrls.searchListUrl,
      queryParameters: {
        'keyword': _keyword,
        'page': _currentPage,
        'limit': _countData,
      },
    );
    bool isSuccess = false;
    if (response.isSuccess) {
      final data = response.responseData;
      if (data != null && data['data'] != null) {
        for (Map<String, dynamic> item in data['data']) {
          _productList.add(ProductListModel.formJson(item));
        }
        // Parsing pagination data
        if (data['pagination'] != null) {
          _totalPages = data['pagination']['totalPages'];
        }
        _currentPage++;
      }
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    _isLoadingMore = false;
    update();
    return isSuccess;
  }

  Future<bool> refreshLoading() {
    _currentPage = 1;
    _productList.clear();
    _totalPages = null;
    return getSearchList();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
