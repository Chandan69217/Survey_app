import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/utilities/location_permisson_handler/LocationCached.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ConstituencyChatAPIService {
  ConstituencyChatAPIService._();
  static const int BYTES = 1;                // 1 byte
  static const int KB = 1024 * BYTES;        // 1 KB = 1024 bytes
  static const int MB = 1024 * KB;           // 1 MB = 1024 KB = 1,048,576 bytes


  static int _getChunkSize(File file){
    return _isImage(file) ? 512 * KB: 1 * MB;
  }

  static Future<File?> compressVideo(File file) async {
    const int maxSizeBytes = 60 * 1024 * 1024;

    File? compressedFile = file;

    try {
      for (var quality in [
        VideoQuality.DefaultQuality,
        VideoQuality.MediumQuality,
        VideoQuality.LowQuality,
      ]) {
        final size = await compressedFile!.length();

        if (size <= maxSizeBytes) {
          return compressedFile;
        }

        final info = await VideoCompress.compressVideo(
          compressedFile.path,
          quality: quality,
          deleteOrigin: false,
        );

        if (info != null && info.file != null) {
          compressedFile = info.file!;
        } else {
          break;
        }
      }

      final finalSize = await compressedFile!.length();
      return finalSize <= maxSizeBytes ? compressedFile : null;

    } catch (e) {
      print('Exception While Video Compression: ${e}');
      return null;
    }
  }

  static Future<String?> createSession({
    required File file,
  }) async {

    try {
      final accessToken = prefs.getString(Consts.accessToken);
      final totalSize = await file.length();

      final headers = {
        'Content-type': 'application/json',
        'Client_source': 'mobile',
      };

      if (accessToken != null) {
        headers['Authorization'] = 'Bearer ${accessToken}';
      }
      final url = Uri.https(
        Urls.baseUrl,
        '/api/chat-discussion/file-uploads/start/',
      );

      final body = {
        "file_name": file.path.split('/').last.toLowerCase(),
        "total_size": totalSize, // bytes
        "chunk_size": _getChunkSize(file), // bytes
      };

      final response = await post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      print('Response Code: ${response.statusCode}, Body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final status = data['success'] ?? false;
        if (status) {
          final sessionId = data['data']['upload_id'];
          return sessionId;
        }
      }
    } catch (exception, trace) {
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }

  static bool _isImage(File file) {
    final ext = p.extension(file.path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.bmp', '.webp'].contains(ext);
  }

  static bool _isVideo(File file) {
    final ext = p.extension(file.path).toLowerCase();
    return ['.mp4', '.mov', '.avi', '.mkv', '.webm'].contains(ext);
  }



  static Future<File?> _compressImage(File file) async {
    final targetPath = "${file.path}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
    );

    return result == null ? null : File(result.path);
  }


  static Future<void> uploadFile({
    required String sessionId,
    required File file,
    required void Function(double percent) onProgress,
  }) async {
    try {
      int chunkSizeBytes = _getChunkSize(file);
      int uploadedBytes = 0;
      int index = 0;

      final fileSize = await file.length();
      final raf = file.openSync(mode: FileMode.read);

      for (int start = 0; start < fileSize; start += chunkSizeBytes, index++) {
        final end = (start + chunkSizeBytes > fileSize)
            ? fileSize
            : start + chunkSizeBytes;
        final chunk = raf.readSync(end - start);

        final uri = Uri.https(
          Urls.baseUrl,
          "/api/chat-discussion/file-uploads/$sessionId/chunk/",
        );

        final request = http.MultipartRequest("POST", uri)
          ..headers.addAll({
            "Client_source": "mobile",
            if (prefs.getString(Consts.accessToken) != null)
              "Authorization": "Bearer ${prefs.getString(Consts.accessToken)}",
          })
          ..fields["chunk_index"] = index.toString()
          ..files.add(
            http.MultipartFile.fromBytes(
              "chunk",
              chunk,
              filename: "${file.uri.pathSegments.last}.part$index",
            ),
          );

        final response = await request.send();
        final resBody = json.decode(await response.stream.bytesToString());
        print('Response Code: ${response.statusCode}, Body: ${resBody}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (resBody["success"] == true && resBody["performed"] == true) {
            uploadedBytes += chunk.length;
            final percent = ((uploadedBytes / fileSize));
            onProgress(percent);
          } else {
            throw Exception(resBody["message"] ?? "Chunk not performed");
          }
        } else {
          throw Exception("Chunk upload failed: ${response.statusCode}");
        }
      }

      raf.closeSync();
    } catch (e, st) {
      print(" Upload failed: $e");
      print(st);
      rethrow;
    }
  }


  static Future<Map<String, dynamic>?> getAllConstituencyChat({
    required String constituencyId,
    required String page,
  }) async {
    try {
      final accessToken = prefs.getString(Consts.accessToken)??'';
      final url = Uri.https(Urls.baseUrl,'/api/chat-discussion/${constituencyId}/public-create/list/',{
        'page' : page
      });
      final response = await get(
        url,
        headers: {
          'content-type': 'application/json',
          'Authorization' : 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final status = body['success'] ?? false;
        if (status) {
          return body;
        }
      }
    } catch (exception, trace) {
      print('Exception: $exception,Trace: $trace}');
    }
    return null;
  }

  static Future<int?> sendMessageWithoutFile({
    required String constituencyId,
    required String statement,
    required String deviceId,
  }) async {
    await LocationCache.init();
    final latitude = LocationCache.lat ?? 0.0;
    final longitude = LocationCache.lng ?? 0.0;
    try {
      final accessToken = prefs.getString(Consts.accessToken)??'';
      final url = Uri.https(Urls.baseUrl, '/api/chat-discussion/${constituencyId}/public-create/');
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-type': 'application/json',
          'Authorization' : 'Bearer ${accessToken}',
        })
        ..fields['statement'] = statement
        ..fields['device_id'] = deviceId
        ..fields['app_name'] = 'mobile'
        ..fields['latitude'] = latitude.toStringAsFixed(6)
        ..fields['longitude'] = longitude.toStringAsFixed(6);

      if (prefs.getString(Consts.name) != null) {
        request..fields['name'] = prefs.getString(Consts.name)!;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Body: ${response.body}');
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['success']??false;
        if(status){
         return data['data']['id'];
        }
      }
    } catch (exception, trace) {
      print('Exception: ${exception} Trace: ${trace}');
    }
    return null;
  }

  static Future<bool> deleteMessage({
    required String constituencyID,
    required String messageId,
    required String deviceId,
  }) async {
    try {
      final accessToken = prefs.getString(Consts.accessToken)??'';
      final uri = Uri.https(
        Urls.baseUrl,
        '/api/chat-discussion/${constituencyID}/${messageId}/public-delete/',
      );
      final response = await delete(
        uri,
        body: json.encode({'device_id': deviceId}),
        headers: {
          'Content-type': 'application/json',
          'Authorization' : 'Bearer $accessToken',
        },
      );
      print('Response code: ${response.statusCode} , Body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final status = body['success'] ?? false;
        if (status) {
          return true;
        }
      }
    } catch (exception, trace) {
      print('Exception: ${exception},Trace: ${trace}');
    }
    return false;
  }

  static Future<int?> sendMessageWithFile({
    required String constituencyId,
    required String statement,
    required String deviceId,
    required String sessionID,
  }) async {
    await LocationCache.init();
    final latitude = LocationCache.lat ?? 0.0;
    final longitude = LocationCache.lng ?? 0.0;
    try {
      final accessToken = prefs.getString(Consts.accessToken)??'';
      final url = Uri.https(
        Urls.baseUrl,
        '/api/chat-discussion/${constituencyId}/${sessionID}/upload-public-create/',
      );
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Authorization' : 'Bearer $accessToken',
          'Cotent-type': 'application/json',
        })
        ..fields['statement'] = statement
        ..fields['device_id'] = deviceId
        ..fields['app_name'] = 'mobile'
        ..fields['latitude'] = latitude.toStringAsFixed(6)
        ..fields['longitude'] = longitude.toStringAsFixed(6);

      if (prefs.getString(Consts.name) != null) {
        request..fields['name'] = prefs.getString(Consts.name)!;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Response Code: ${response.statusCode} Body : ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Body: ${response.body}');
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['success']??false;
        if(status){
          return data['data']['id'];
        }
      }
    } catch (exception, trace) {
      print('Exception: ${exception} Trace: ${trace}');
    }
    return null;
  }



}




