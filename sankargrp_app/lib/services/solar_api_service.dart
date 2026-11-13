import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/solar_system.dart';

class SolarApiException implements Exception {
  final String message;
  const SolarApiException(this.message);

  @override
  String toString() => message;
}

class SolarApiService {
  // Dynamically resolves host for Android Physical Devices, Emulators, Web, & Desktop
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    if (Platform.isAndroid) {
      // In physical device connected via USB with adb reverse or LAN:
      // Primary: localhost (via adb reverse tcp:3000 tcp:3000)
      // Fallback: 10.0.2.2 (Android Emulator loopback)
      return 'http://localhost:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  // Fallback candidate URLs to try sequentially when running on Android
  static List<String> get _candidateUrls {
    if (kIsWeb) return const ['http://localhost:3000/api'];
    if (Platform.isAndroid) {
      return const [
        'http://localhost:3000/api', // Physical device with `adb reverse`
        'http://10.0.2.2:3000/api', // Standard Android Emulator
        'http://192.168.0.107:3000/api', // Local WiFi LAN IP
      ];
    }
    return const ['http://localhost:3000/api'];
  }

  /// Sends OTP to the given 10-digit mobile number with optional fullName & signup flag
  static Future<Map<String, dynamic>> sendOtp(String phone,
      {String? fullName, bool isSignUp = false}) async {
    String lastError = 'Cannot connect to backend server.';

    for (final base in _candidateUrls) {
      try {
        final response = await http
            .post(
              Uri.parse('$base/auth/send-otp'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'phone': phone,
                if (fullName != null && fullName.isNotEmpty) 'fullName': fullName,
                'isSignUp': isSignUp,
              }),
            )
            .timeout(const Duration(seconds: 4));

        final decoded = json.decode(response.body);
        if (response.statusCode == 200 && decoded['success'] == true) {
          return decoded as Map<String, dynamic>;
        } else {
          throw SolarApiException(
              decoded['message']?.toString() ?? 'Failed to send OTP.');
        }
      } on SolarApiException {
        rethrow;
      } catch (e) {
        lastError = e.toString();
      }
    }
    throw SolarApiException(
        'Cannot connect to backend server at $baseUrl: $lastError');
  }

  /// Verifies OTP code
  static Future<Map<String, dynamic>> verifyOtp(
      String phone, String otp) async {
    String lastError = 'Cannot connect to backend server.';

    for (final base in _candidateUrls) {
      try {
        final response = await http
            .post(
              Uri.parse('$base/auth/verify-otp'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'phone': phone, 'otp': otp}),
            )
            .timeout(const Duration(seconds: 4));

        final decoded = json.decode(response.body);
        if (response.statusCode == 200 && decoded['success'] == true) {
          return decoded as Map<String, dynamic>;
        } else {
          throw SolarApiException(
              decoded['message']?.toString() ?? 'Invalid OTP code entered.');
        }
      } on SolarApiException {
        rethrow;
      } catch (e) {
        lastError = e.toString();
      }
    }
    throw SolarApiException('Server verification error: $lastError');
  }

  /// Fetches all solar systems with multi-host fallback for Android
  static Future<List<SolarSystem>> fetchSolarSystems() async {
    String lastError = 'Connection failed';

    for (final base in _candidateUrls) {
      try {
        final response = await http
            .get(Uri.parse('$base/solar-systems'))
            .timeout(const Duration(seconds: 4));

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          if (decoded['success'] == true && decoded['data'] is List) {
            return (decoded['data'] as List)
                .map((item) =>
                    SolarSystem.fromJson(item as Map<String, dynamic>))
                .toList();
          }
        }
      } catch (e) {
        lastError = e.toString();
      }
    }

    throw SolarApiException(
        'Failed to connect to backend server ($baseUrl). Please ensure the backend server is running.\nDetails: $lastError');
  }

  /// Fetches single solar system details by ID
  static Future<SolarSystem> fetchSolarSystemById(String id) async {
    for (final base in _candidateUrls) {
      try {
        final response = await http
            .get(Uri.parse('$base/solar-systems/$id'))
            .timeout(const Duration(seconds: 4));

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          if (decoded['success'] == true && decoded['data'] != null) {
            return SolarSystem.fromJson(
                decoded['data'] as Map<String, dynamic>);
          }
        }
      } catch (_) {}
    }

    throw const SolarApiException('Solar system details not found on server.');
  }

  /// Fetches dashboard summary statistics
  static Future<DashboardSummary> fetchDashboardSummary() async {
    for (final base in _candidateUrls) {
      try {
        final response = await http
            .get(Uri.parse('$base/dashboard/summary'))
            .timeout(const Duration(seconds: 4));

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          if (decoded['success'] == true && decoded['data'] != null) {
            return DashboardSummary.fromJson(
                decoded['data'] as Map<String, dynamic>);
          }
        }
      } catch (_) {}
    }

    throw const SolarApiException(
        'Failed to fetch live dashboard summary from backend server.');
  }
}
