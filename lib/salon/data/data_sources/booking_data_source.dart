import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class BookingDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  // * 영업시간 목록 불러오기
  Future<http.Response> getSalonHourAPI() async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/salon/hour';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      debugPrint('영업시간 목록: ${response.body}');
      return response;
    } else {
      throw Exception('영업시간 목록을 불러오지 못했습니다.');
    }
  }

  // * 예약하기
  Future<http.Response> postReservationAPI(
      int serviceId, String reservationDate, String reservationTime) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/salon/reservation';
    final body = jsonEncode({
      'salon_service_id': serviceId,
      'r_date': reservationDate,
      'r_time': reservationTime
    });

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    return response;
  }
}