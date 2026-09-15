import 'dart:async';
import 'dart:convert';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/auth/profile_model.dart';
import 'package:arena/utils/app_shared_preferances.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class ProfileService {
  static const _profilePath = ConstantApi.profile;

  Future<ProfileModel> updateProfile(String name) async {
    try {
      final response = await Client.dio.patch(
        _profilePath,
        data: {"name": name},
      );

      final body = ProfileModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        await AppSharedPreferances.write(
          "cached_profile",
          jsonEncode(response.data),
        );
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memperbarui profile");
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMessage = extractServerMessage(e);
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Waktu koneksi habis');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Tidak ada koneksi internet atau server tidak dapat dijangkau',
        );
      }
      throw Exception(
        serverMessage ?? 'Gagal memperbarui profile\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<ProfileModel> getProfile() async {
    try {
      final response = await Client.dio.get(_profilePath);

      final body = ProfileModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        await AppSharedPreferances.write(
          "cached_profile",
          jsonEncode(response.data),
        );
        return body;
      } else {
        throw Exception("Gagal mengambil profile");
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMessage = extractServerMessage(e);
      final cachedProfile = await AppSharedPreferances.read("cached_profile");
      try {
        return ProfileModel.fromJson(jsonDecode(cachedProfile));
      } catch (_) {}
          if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Waktu koneksi habis');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Tidak ada koneksi internet atau server tidak dapat dijangkau',
        );
      }
      throw Exception(
        serverMessage ?? 'Gagal mengambil profile\n(Status: $statusCode)',
      );
    } catch (e) {
      final cachedProfile = await AppSharedPreferances.read("cached_profile");
      try {
        return ProfileModel.fromJson(jsonDecode(cachedProfile));
      } catch (_) {}
          throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
