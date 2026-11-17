import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_exception.dart';
import '../core/network/dio_client.dart';
import '../models/calling_list_model.dart';

class CallingListService {
  final Dio _dio = DioClient.instance.dio;

  /// The docs example shows a single object; handle both an object and a list.
  Future<List<CallingListModel>> getLists(String userId) async {
    try {
      final res = await _dio.get(
        ApiConstants.lists,
        queryParameters: {'userId': userId},
      );
      final data = res.data;
      if (data is List) {
        return data
            .map((e) => CallingListModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      if (data is Map) {
        return [CallingListModel.fromJson(Map<String, dynamic>.from(data))];
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<CallingListDetails> getListDetails(String listId) async {
    try {
      final res = await _dio.get(ApiConstants.listDetails(listId));
      return CallingListDetails.fromJson(Map<String, dynamic>.from(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
