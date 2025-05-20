import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'dio_interceptor.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
)..interceptors.add(AppInterceptor());
