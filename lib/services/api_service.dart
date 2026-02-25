import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  Future<Map<String, dynamic>> submitAudio(List<int> audioBytes) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(audioBytes, filename: 'audio.wav'),
    });
    final response = await _dio.post('/audio/submit', data: formData);
    return response.data;
  }

  Future<Map<String, dynamic>> sendChatMessage(String message) async {
    final response = await _dio.post('/chat', data: {'message': message});
    return response.data;
  }
}
