import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../data/review_model.dart';

class ReviewController extends GetxController {
  final Logger _logger = Logger();
  bool _inProgress = false;
  bool _isLoadingMore = false;
  final int _countData = 10;
  int _currentPage = 1;
  int? _totalPages;
  String? _lastProductId;

  String? _errorMessage;
  final List<ReviewModel> _reviewList = [];

  bool get inProgress => _inProgress;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<ReviewModel> get reviewList => _reviewList;

  Future<bool> getReviewDetails(String productId) async {
    // Reset state if product ID changes
    if (_lastProductId != productId) {
      _lastProductId = productId;
      _currentPage = 1;
      _totalPages = null;
      _reviewList.clear();
    }

    // Stop if we already loaded all pages
    if (_totalPages != null && _currentPage > _totalPages!) {
      _logger.i('All review pages already loaded. Skip.');
      return false;
    }

    // Avoid multiple concurrent requests
    if (_inProgress || _isLoadingMore) {
      _logger.w('Review request already in progress. Skipping.');
      return false;
    }

    if (_currentPage == 1) {
      _inProgress = true;
      _reviewList.clear();
    } else {
      _isLoadingMore = true;
    }
    update();

    final url = AppUrls.reviewUrl(productId);
    _logger.i('🟡 [Review API] GET → $url');
    _logger.i('🟡 [Review API] QueryParams → page: $_currentPage, count: $_countData');

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: url,
      queryParameters: {
        'page': _currentPage,
        'count': _countData,
      },
    );

    _logger.i('🟢 [Review API] Status: ${response.responseCode}');

    bool isSuccess = false;
    if (response.isSuccess) {
      final data = response.responseData;
      _logger.i('🟢 [Review API] Raw response data: $data');

      List<dynamic> rawList = [];
      if (data is List) {
        rawList = data;
      } else if (data is Map) {
        if (data['data'] is List) {
          rawList = data['data'] as List<dynamic>;
        } else if (data['reviews'] is List) {
          rawList = data['reviews'] as List<dynamic>;
        }
      }

      if (rawList.isNotEmpty) {
        _logger.i('🟢 [Review API] Parsed ${rawList.length} review(s).');

        for (var item in rawList) {
          if (item is Map<String, dynamic>) {
            _reviewList.add(ReviewModel.formJson(item));
          } else if (item is Map) {
            _reviewList.add(ReviewModel.formJson(Map<String, dynamic>.from(item)));
          }
        }
      }

      if (data is Map && data['pagination'] != null) {
        _totalPages = data['pagination']['totalPages'];
        _logger.i('🟢 [Review API] Pagination → totalPages: $_totalPages');
      }

      _currentPage++;
      _logger.i('🟢 [Review API] Internal list size now: ${_reviewList.length}');
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
      _logger.e('🔴 [Review API] Failed: ${response.errorMessage}');
    }

    _inProgress = false;
    _isLoadingMore = false;
    update();
    return isSuccess;
  }

  Future<bool> refreshLoading(String productId) {
    _logger.i('🔄 [Review API] Refresh triggered for product: $productId');
    _currentPage = 1;
    _lastProductId = productId;
    _reviewList.clear();
    _totalPages = null;
    return getReviewDetails(productId);
  }
}

