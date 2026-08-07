import 'package:dio/dio.dart';

import 'failure.dart';

class DioFailure extends Failure {
  const DioFailure(super.message);

factory DioFailure.fromDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return const DioFailure("انتهت مهلة الاتصال");

    case DioExceptionType.sendTimeout:
      return const DioFailure("انتهت مهلة إرسال الطلب");

    case DioExceptionType.receiveTimeout:
      return const DioFailure("انتهت مهلة استقبال البيانات");

    case DioExceptionType.badCertificate:
      return const DioFailure("شهادة الأمان غير صالحة");

    case DioExceptionType.badResponse:
      return DioFailure.fromStatusCode(
        e.response?.statusCode ?? 0,
        e.response?.data,
      );

    case DioExceptionType.cancel:
      return const DioFailure("تم إلغاء الطلب");

    case DioExceptionType.connectionError:
      return const DioFailure("لا يوجد اتصال بالإنترنت");

    case DioExceptionType.unknown:
    default:
      return const DioFailure("حدث خطأ غير متوقع");
  }
}

  factory DioFailure.fromStatusCode(
    int statusCode,
    dynamic response,
  ) {
    switch (statusCode) {
      case 400:
        return const DioFailure("طلب غير صالح");

      case 401:
        return const DioFailure("البريد الإلكتروني أو كلمة المرور غير صحيحة");

      case 403:
        return const DioFailure("ليس لديك صلاحية");

      case 404:
        return const DioFailure("البيانات غير موجودة");

      case 422:
        return DioFailure(
          response["message"] ?? "البيانات المدخلة غير صحيحة",
        );

      case 500:
        return const DioFailure("حدث خطأ في الخادم");

      default:
        return const DioFailure("حدث خطأ، حاول مرة أخرى");
    }
  }
}