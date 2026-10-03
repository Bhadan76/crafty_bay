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

  String? _errorMessage;
  final List<ReviewModel> _reviewList = [];

  bool get inProgress => _inProgress;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<ReviewModel> get reviewList => _reviewList;

  Future<bool> getReviewDetails(String productId) async {
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
      _reviewList.clear(); // নতুন প্রোডাক্ট লোড করার আগে আগের রিভিউ ক্লিয়ার করা হচ্ছে
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

      if (data != null && data['data'] != null) {
        final rawList = data['data'] as List<dynamic>;
        _logger.i('🟢 [Review API] Parsed ${rawList.length} review(s).');

        for (Map<String, dynamic> item in rawList.cast<Map<String, dynamic>>()) {
          _reviewList.add(ReviewModel.formJson(item));
        }
        // Parsing pagination data
        if (data['pagination'] != null) {
          _totalPages = data['pagination']['totalPages'];
          _logger.i('🟢 [Review API] Pagination → totalPages: $_totalPages');
        }
        _currentPage++;
        _logger.i('🟢 [Review API] Internal list size now: ${_reviewList.length}');
      } else {
        _logger.w('🟠 [Review API] Response had no "data" key. Full body: $data');
      }
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
    _reviewList.clear();
    _totalPages = null;
    return getReviewDetails(productId);
  }
}
