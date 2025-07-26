import 'dart:convert';  
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  final String cloudName = 'dcsb7l9xu';
  final String apiKey = '826663314578712';
  final String apiSecret = '_iuUomXN-ihgxrpeAeMF9CTepIw';

  factory CloudinaryService() {
    return _instance;
  }

  CloudinaryService._internal();

  String _generateSignature(Map<String, String> params) {
    // Sort parameters alphabetically
    var sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
    
    // Create string to sign
    String stringToSign = sortedParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&') + apiSecret;
    
    // Generate signature
    return sha1.convert(utf8.encode(stringToSign)).toString();
  }

  Future<String> uploadImage(String filePath) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final params = {
        'timestamp': timestamp,
        'api_key': apiKey,
        'resource_type': 'image',
      };

      final signature = _generateSignature(params);
      params['signature'] = signature;

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields.addAll(params)
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url'] ?? '';
      } else {
        throw Exception('Failed to upload image: ${jsonResponse['error']?['message']}');
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  Future<String> uploadVideo(String filePath) async {
    try {
      
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final params = {
        'timestamp': timestamp,
        'api_key': apiKey,
        'resource_type': 'video',
      };

      final signature = _generateSignature(params);
      params['signature'] = signature;

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/video/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields.addAll(params)
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url'] ?? '';
      } else {
        throw Exception('Failed to upload video: ${jsonResponse['error']?['message']}');
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      throw Exception('Failed to upload video to Cloudinary');
    }
  }
} 
